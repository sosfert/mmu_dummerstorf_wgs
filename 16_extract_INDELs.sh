#!/bin/bash
gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicSNPs.vcf.gz \
	--select-type-to-include INDEL \
	--restrict-alleles-to BIALLELIC \
	-O cohort_biallelicINDELs.vcf.gz

