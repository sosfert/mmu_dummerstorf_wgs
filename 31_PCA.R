library(gdsfmt)
library(SNPRelate)
library(SeqArray)
library(dplyr)

# Make PCA
genofile <- seqOpen("cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.gds")
pca <- snpgdsPCA(genofile)

# PC percentages export
data.frame(PC=1:7, varprop = pca$varprop[1:7]*100) %>% write.csv("pc_pct_full_snp_set.csv")

# Export table of eigenscores

tab <- data.frame(sample.id = pca$sample.id,
			PC1 = pca$eigenvect[,1],    # the first eigenvector
			PC2 = pca$eigenvect[,2],    # the second eigenvector
			PC3 = pca$eigenvect[,3],    # the third eigenvector
			PC4 = pca$eigenvect[,4],    # the fourth eigenvector
			PC5 = pca$eigenvect[,5],
			PC6 = pca$eigenvect[,6],
			PC7 = pca$eigenvect[,7],
			stringsAsFactors = FALSE)

write.csv(tab, "pc_eigenscores_full_snp_set.csv")
# PCA plots were done based on the last data set. Code on request.

