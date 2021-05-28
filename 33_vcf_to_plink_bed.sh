#!/bin/bash

# Convert to bed with plink to pass it to admixture

plink --vcf cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.vcf --make-bed --chr 1-19 --out cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered
