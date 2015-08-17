SHELL := /bin/bash

all: Data data/miRNA_positions data/gene_positions data/miRNA_expression data/gene_expression

setup: 
	mkdir data
	mkdir results

clean:
	rm results/*

Data: data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt

data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt: 
	wget -P ./data ftp://ftp.ebi.ac.uk/pub/databases/microarray/data/experiment/GEUV/E-GEUV-2/analysis_results/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt

data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf:
	wget -P ./data ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130723_phase3_wg/merged_sv_genotypes/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.gz 
	gunzip data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.gz 

data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt:
	wget -P ./data http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz
	gunzip data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz

#TODO: Download start and end positions for miRNA and genes to make analysis more accurate
data/miRNA_positions: data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt
	cut -f 2-4 data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt > data/miRNA_positions

data/gene_positions: data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt
	cut -f 2-4 data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt > data/gene_positions

data/miRNA_expression: data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt
	paste <(cut -f 1 data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt) <(cut -f 5- data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt) > data/miRNA_expression

data/gene_expression: data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt
	paste <(cut -f 1 data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt) <(cut -f 5- data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt) > data/gene_expression
