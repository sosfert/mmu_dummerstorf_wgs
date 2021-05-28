#!/bin/bash

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicSNPs_VQSR95.vcf \
	-O cohort_biallelicSNPs_VQSR95_PASS.vcf \
	--exclude-filtered

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicINDELs_VQSR99.vcf \
	-O cohort_biallelicINDELs_VQSR99_PASS.vcf \
	--exclude-filtered

