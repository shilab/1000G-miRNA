#!/usr/bin/perl
use strict;
use warnings;
use Math::Round;

my $filename = $ARGV[0];
my $filename_pos = $ARGV[1];

my %pos;
#my $filename_pos = "ALL.wgs.phase3_dels_merged_genome_strip.20130502.dels.low_coverage.genotypes.vcf.samples.pos";
#my $filename_pos = "ALL.wgs.20130502.SV.low_coverage.genotypes.for-integration.flt-miss-50.vcf.samples.pos";
open(FILE,$filename_pos) || die "Can't open file $filename_pos";
while (<FILE>)
{
	my @temp = split("\t",$_);
	my $id = $temp[0];
	my $position = $temp[2];
	$pos{$id} = $position;
}


#my $filename = "ALL.wgs.20130502.SV.low_coverage.genotypes.for-integration.flt-miss-50.vcf.samples.matrix2.filter_MAF2";
#my $filename = "ALL.wgs.phase3_dels_merged_genome_strip.20130502.dels.low_coverage.genotypes.vcf.samples.matrix2.filter";
my $output="snpid\tchr\tpos\n";
my $matrixID="";
open(FILE,$filename) || die "Can't open file $filename";
while (<FILE>)
{
	if ($_=~/^snpid/)
	{
		next;
	}
	my @temp = split("\t",$_);
	my $id = $temp[0];

	my $position = $pos{$id};
	my @pos_split = split("-",$position);
	(my $chr, my $start, my $end) = @pos_split;

	my $midpoint = $start+ round(($end-$start)/2);

	$output.="$id\t$chr\t$midpoint\n";
}

open FILE,">"."$filename" . ".meqtl_pos" or die $!;
print FILE $output;
close FILE;
