#!/bin/bash

# Split by population by passing a population list 

pop=$1
pop_sample_list=$2
in_vcf=cohort_biallelicSNPs_VQSR95_PASS_withmissingness.filtered_thinned.recode.vcf

bcftools view --samples-file $pop_sample_list $in_vcf -o ${pop}_thinned.vcf

