#!/bin/bash

# Loop over each interval for a given chromosome

for db in chr_intervals_dir
do
	gatk --java-options "-Xmx100G" GenotypeGVCFs \
		-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
		-V gendb://$db \
		-O chr_dir/${db}.vcf.gz \
		--allow-old-rms-mapping-quality-annotation-data
done

# concatenate chr-interval vcf files
time bcftools concat chr_dir/*.vcf.gz -Ou | bcftools sort -Oz -o cohort_chr.vcf.gz

# Validate chr VCF
gatk ValidateVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_chr.vcf.gz \
	--validation-type-to-exclude ALL


