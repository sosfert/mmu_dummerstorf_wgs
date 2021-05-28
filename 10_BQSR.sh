#!/bin/bash
gatk BaseRecalibrator \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-I alignment.RG.merged.sorted.dedup.bam \
	--known-sites mus_musculus.vcf \
	-O alignment.RG.merged.sorted.dedup.bqsr.table

