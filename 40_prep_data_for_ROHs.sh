#!/bin/bash

# Extract allele information, including allele frequency.Compres and index.
vcf_fl= cohort_biallelicSNPs_VQSR95_PASS_withmissingness.filtered.vcf
bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%AF\n' $vcf_fl | bgzip -c > ${vcf_fl/.vcf/.AF.tab.gz} && tabix -s1 -b2 -e2 ${vcf_fl/.vcf/.AF.tab.gz}

