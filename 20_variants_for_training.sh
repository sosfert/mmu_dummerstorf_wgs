#!/bin/bash

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicSNPs.vcf.gz \
	-L truth_training.intervals \
	-O cohort_biallelicSNPs_best.vcf

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicINDELs.vcf.gz \
	-L truth_training_INDELs.intervals \
	-O cohort_biallelicINDELs_best.vcf

