#!/bin/bash

# Compare each selected population with FZTDU
pop1=[DUK,DUC,DU6,DU6P,DUhLB,FERT]
pop2=FZTDU
vcf_nm=cohort_biallelicSNPs_VQSR95_PASS_withmissingness.filtered.vcf
out=${pop1}_vs_${pop2}
vcftools --vcf $vcf_nm --weir-fst-pop samples_$pop1 --weir-fst-pop samples_$pop2 --out $out

