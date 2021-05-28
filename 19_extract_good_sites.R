#!/bin/bash

# Thresholds were chosen after careful exploratory data analysis (code on request).

# SNPs
vroom("cohort_biallelicSNPs.table") %>%
	filter(MQ > 55 & FS < 0.1 & QD > 25.0 & SOR < 1.0) %>%
	filter(MQRankSum > -0.5 & MQRankSum < 0.5) %>%
	filter(ReadPosRankSum > -0.5 & ReadPosRankSum < 0.5) %>%
	mutate(L=paste0(CHROM,":",POS,"-",POS)) %>% 
	dplyr::select(L) %>%
	write.table("truth_training.intervals",quote = F, row.names = F, col.names = F)

# INDELs
# Mapping quality annotations excluded.
# Not applicable for INDELs
vroom("cohort_biallelicINDELs.table") %>% 
	filter(QD > 5 & FS < 1 & SOR < 3) %>%
	filter( (ReadPosRankSum < 2 & ReadPosRankSum > -2) | is.na(ReadPosRankSum) ) %>% 
	mutate(tst = paste0(CHROM,":",POS,"-",POS)) %>% 
	dplyr::select(tst) %>% 
	write.table("truth_training_INDELs.intervals", quote = FALSE, row.names = FALSE, col.names = FALSE)

