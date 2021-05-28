#!/bin/bash

# Get alt allele frequency
# Separate main final vcf beforehand.

bcftools view --samples-file pop_sample_list $in_vcf -o pop.vcf
vcftools --freq --vcf pop.vcf --out ${pop.vcf/.vcf/}

# From these data, allele frequencies were visualized as histograms and classified as fixed-alt, fixed-ref and polymorphic. Code on request.
