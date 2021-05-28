#!/bin/bash

sample_i=$1

# Get ROHs one sample at a time.
vcf_fl=cohort_biallelicSNPs_VQSR95_PASS_withmissingness.filtered.vcf
out_fl=${sample_i}.roh
bcftools roh --AF-file ${vcf_fl/.vcf/.AF.tab.gz} $vcf_fl -o $out_fl -S ${sample_i}

