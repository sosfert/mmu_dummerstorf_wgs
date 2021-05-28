library(gdsfmt)
library(SNPRelate)
library(SeqArray)
library(dplyr)

genofile <- seqOpen("cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.gds")

ibs.hc <- snpgdsHCluster(snpgdsIBS(genofile))

sample_info <- read.csv("sample_info.csv") 

# Make sure that samples have the same order before assigning groups
data.frame(x=ibs.hc$sample.id,y=sample_info$sample_id)

rv <- snpgdsCutTree(ibs.hc, samp.group=as.factor(sample_info$Linie))

# save for downstream analysis
saveRDS(rv$dendrogram, "../data/dendrogram_full_snp_set.rds")

# Visualizations were done based on the last data set using pkg "ape" Code on request.
