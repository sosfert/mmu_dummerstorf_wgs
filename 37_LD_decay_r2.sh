#!/bin/bash

pop=$1

# Get r2 between SNP pairs, passing one vcf per pop at a time
# "--ld-window-r2 0" ... output all r2 scores (min = 0)
# "--ld-window 999999" ... max number of snps in window 
# "--ld-window-kb 5000" ... window size: set to 5Mb 

in_fl= ${pop}_thinned.vcf
out_fl=$(echo $in_fl | sed 's/.vcf//')
plink --vcf $in_fl --make-bed --out ${out_fl}.plink
plink --bfile ${out_fl}.plink --r2 --ld-window-r2 0 --ld-window 999999 --ld-window-kb 5000 -out ${out_fl}.plink --allow-extra-chr

