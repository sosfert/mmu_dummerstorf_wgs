#!/bin/bash

# Since GenomicsDBImport cannot process the whole genome in a reasonable amount time, same when running one single chromosome, it is necessary to split the genome according to natural limits.

# Intervals should be small enough in order to complete within a reasonable amount of time (i.e. max 5Mb). Multiple intervals can be run in parallel.

# Store all interval-outputs into a chromosome specific directory

gatk GenomicsDBImport \
	-V sample1.RG.merged.sorted.dedup.bqsr.g.vcf \
	-V sample2.RG.merged.sorted.dedup.bqsr.g.vcf \
	-V sample3.RG.merged.sorted.dedup.bqsr.g.vcf \
	-V ... \
	--genomicsdb-workspace-path chr_interval_dir \
	--intervals chr_interval_subset.bed \
	-- batch-size=50 

