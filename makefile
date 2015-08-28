SHELL := /bin/bash

all: Data Code 

setup: 
	mkdir data
	mkdir results

clean:
	rm results/*

Data: data/miRNA_positions data/gene_positions data/miRNA_expression.out data/gene_expression.out data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.pos

Code: code/overlap.py

code/overlap.py:
	curl https://raw.githubusercontent.com/shilab/sample_overlap/master/overlap.py > code/overlap.py

data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt: 
	wget -P ./data ftp://ftp.ebi.ac.uk/pub/databases/microarray/data/experiment/GEUV/E-GEUV-2/analysis_results/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt

data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf:
	wget -P ./data ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130723_phase3_wg/merged_sv_genotypes/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.gz 
	gunzip data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.gz 

data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt:
	wget -P ./data http://www.ebi.ac.uk/arrayexpress/files/E-GEUV-1/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz
	gunzip data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz

data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.newID: data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt
	sed 's/\.[0-9]\{1,2\}\t/\t/g' data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt > data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.newID

data/miRNA_positions: data/hsa.gff3
	python code/extract_miRNA_position.py data/miRNA_expression data/hsa.gff3 data/miRNA_position

data/gene_positions: data/Homo_sapiens.GRCh37.75.gtf
	python code/extract_gene_position.py data/Homo_sapiens.GRCh37.75.gtf data/gene_positions

data/miRNA_expression: data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt
	paste <(cut -f 1 data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt) <(cut -f 5- data/GD452.MirnaQuantCount.1.2N.50FN.samplename.resk10.txt) > data/miRNA_expression

data/gene_expression: data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.newID
	paste <(cut -f 1 data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.newID) <(cut -f 5- data/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.newID) > data/gene_expression

data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.matrix: data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf
	perl code/parse.pl data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf

data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.pos: data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.matrix

data/miRNA_expression.out: data/miRNA_expression data/gene_expression code/overlap.py
	python code/overlap.py data/miRNA_expression data/gene_expression

data/gene_expression.out: data/miRNA_expression.out

data/Homo_sapiens.GRCh37.75.gtf:
	wget -P ./data ftp://ftp.ensembl.org/pub/grch37/release-81/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
	gunzip data/Homo_sapiens.GRCh37.75.gtf.gz

data/hsa.gff3:
	wget -P ./data ftp://mirbase.org/pub/mirbase/18/genomes/hsa.gff3
