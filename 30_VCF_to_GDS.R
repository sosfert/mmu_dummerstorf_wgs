library(gdsfmt)
library(SNPRelate)
library(SeqArray)
library(dplyr)

# Convert VCF to GDS
vcf <- "cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.vcf"
seqVCF2GDS(vcf, "cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.gds")

