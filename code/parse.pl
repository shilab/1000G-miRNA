#!/usr/bin/perl
use strict;
use warnings;

my $filename = $ARGV[0];
my %geno_hash;

my @temp;
my $output;
my $matrix_output;
my $ID;
my $IDpos;
my $end;
my $type;
my $notcaught = "";
my $line;
my $lines;
open(FILE,$filename) || die "Can't open file $filename";
my $counter;
while (<FILE>)
{
	chomp;
	if ($_=~/^\#\#/)
	{
		next;
	}
	elsif ($_ =~/^\#/)
	{
		my $header = $_;
		my @header = split("\t",$_);
		@header = splice(@header,9);
		$header = join("\t",@header);
		$matrix_output.="snpid\t$header\n";
	}
	else
	{
		@temp = split("\t",$_);
        	my $chromosome = shift(@temp);
        	if ($chromosome !~ /^\d/)
		{
			next;
		}	
		my $pos = shift(@temp);
		$pos+=1;
        my $id = shift(@temp);
		my $ref = shift(@temp);
		my $alt = shift(@temp);
		my $qual = shift(@temp);
		my $filter = shift(@temp);
		my $info = shift(@temp);
		my $format = shift(@temp);
		
		my @IDinfo = split(";",$info);
		my $i=0;
		foreach(@IDinfo)
		{
			if($_=~/^END=.*[0-9]/)
			{
				$end=$&;
				my @end = split("=",$end);
				$end = $end[-1];
			}
			elsif($_=~/SVLEN=.[0-9]*/)
			{
				if ($& ne "#")
				{
					my @len = split("=",$&);
					my $len = $len[-1];
				    if ($IDinfo[$i-1] =~/,-/)
					{
						$end = $pos-$len;
					}
					else
					{
						$end = $pos+$len;
					}
				}
			}
			if ($_=~/SVTYPE=[A-Z]*/)
			{
				$type = $&;
				my @type = split("=",$type);
				$type=$type[-1];
				if ($type eq "INS")
				{
					$type = "NUMTS";
				}
			}
			$i++;
		}
		$ID=$id;
		$IDpos.=$id . "\t" . $type . "\t" . $chromosome . "-" . $pos . "-" . $end . "-$type\n";
				
		my $matrix;
		
		my $total=0;
		my $count=0;
		foreach(@temp)
		{
		    my $geno;
		    if ($_ eq ".")
		    {
				$geno = "NA";
		    }
		    my @sample = split(":",$_);
		    my $raw = $sample[0];
			if ($raw=~/[0-9]+\|[0-9]+/)
		    {
		    	my @raw = split(/\|/,$raw);
				if ($type eq "DEL")
				{
					$geno = 2 - $raw[0] - $raw[1];
				}
				else
				{
		    		$geno = $raw[0]+$raw[1];
		    	}
		    }
			elsif ($raw =~ /\./)
            {
            	$geno = "NA";
            }
		    else
		    {
				if ($type eq "DEL")
				{
					$geno = 2-$raw;
				}
				else
				{
					$geno = $raw;
		    	}
		    }
		    $matrix.="$geno\t";
		    
		}
		$matrix_output.="$ID\t$matrix\n";
	}
	$counter++;
	if ($counter%1000==0)
	{
		print "$counter\n";
	}
}

close FILE;

open FILE,">"."$filename" . ".matrix" or die $!;
print FILE $matrix_output;
close FILE;

open FILE,">"."$filename" . ".pos" or die $!;
print FILE $IDpos;
close FILE;
