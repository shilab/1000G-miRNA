library('MatrixEQTL')
source('code/mxeqtl.R')

sv_mirna<-mxeqtl('data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.matrix.out','data/ALL.wgs.mergedSV.v3.20130502.svs.genotypes.vcf.matrix.out.meqtl_pos','data/miRNA_expression.out.norm','data/miRNA_positions','results/SV-miRNA-cisResults',0.05,qq='results/SV-miRNA-qq.pdf')
