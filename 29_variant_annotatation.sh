#!/bin/bash

IN=cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.vcf
OUT=${IN/.vcf/.ann.vcf}

java -Xmx4g -jar snpEff.jar -csvStats ${IN/.vcf/.summary.csv} GRCm38.86 $IN > $OUT
