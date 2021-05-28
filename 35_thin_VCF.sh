#!/bin/bash

# "--thin <integer> Thin sites so that no two sites are within the specified distance from one another."
# separating snps by 100K bp results in ~23K SNPs in total. This is similar as what it was suggested by https://www.biostars.org/p/347796/

vcf_fl=cohort_biallelicSNPs_VQSR95_PASS_withmissingness.filtered.vcf
vcftools --vcf $vcf_fl --recode --recode-INFO-all --thin 100000 --out ${vcf_fl/.vcf/_thinned}

