#!/bin/bash

# Another training set was included from available variants downloaded from the Mouse Genomes Project (MGP version 5 "Keane, T. M. et al. Mouse genomic variation and its effect on phenotypes and gene regulation. Nature 477, 289-294 (2011)")

gatk VariantRecalibrator \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicSNPs.vcf.gz \
	--resource TRUTH,known=false,training=true,truth=true,prior=12.0:cohort_biallelicSNPs_best.vcf \
	--resource sanger,known=false,training=true,truth=false,prior=10.0:mgp.v5.merged.snps_all.dbSNP142_PASS_final.vcf \
	--resource dbsnp,known=true,training=false,truth=false,prior=2.0:mus_musculus.vcf \
	-an MQ -an QD -an FS -an MQRankSum -an ReadPosRankSum -an SOR \
	-mode SNP \
	--target-titv 2.0 \
	-tranche 100.0 -tranche 99.9 -tranche 99 -tranche 95.0 -tranche 90.0 \
	--output cohort_biallelicSNPs.recal \
	-tranches-file cohort_biallelicSNPs.tranches \
	--rscript-file cohort_biallelicSNPs_plots.R

