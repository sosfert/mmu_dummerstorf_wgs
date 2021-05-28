#!/bin/bash

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort.vcf.gz \
	--select-type-to-include SNP \
	--restrict-alleles-to BIALLELIC \
	-O cohort_biallelicSNPs.vcf.gz

