#!/bin/bash

library(dplyr)
library(vroom)
library(stringr)
options(scipen=999)

# Load genotype table
gt_tab <- vroom("cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.table")

# sample info 
sample_info <- read.csv("sample_info_batch.csv", stringsAsFactors = F)

# Get sites with at least N non-missing samples
idx2 <- gt_tab %>%
	dplyr::select(-CHROM,-POS) %>%
	apply(1, function(x){
		      #x=gt_tab %>% dplyr::select(-CHROM,-POS) %>% .[1,] %>% unlist()

		      # count calls (non ./.) per group and check if N is >= 15 samples (except DU6)
		      xx <- tapply(x[sample_info$Linie != "DU6"],
				   sample_info$Linie[sample_info$Linie != "DU6"],
				   function(gt) sum(gt != "./.") >= 15)

		      # count calls (non ./.) in DU6 and check if N is >= 12 samples
		      yy <- tapply(x[sample_info$Linie == "DU6"],
				   sample_info$Linie[sample_info$Linie == "DU6"],
				   function(gt) sum(gt != "./.") >= 12)

		      # if all groups pass the min N per group (15-rest or 12-DU6)
		      c(xx,yy) %>% all()
})


# Define output file name
out_nm <- paste0("../output/keep_[snps,indels]_DU6_12_REST_15", ".intervals")

# Get and export intervals for GATK
gt_tab %>%
	dplyr::select(CHROM,POS) %>%
	.[idx2,] %>%
	mutate(tmp = paste0(CHROM,":",POS,"-",POS)) %>%
	dplyr::select(tmp) %>%
	write.table(out_nm, quote = F, col.names = F, row.names = F)


