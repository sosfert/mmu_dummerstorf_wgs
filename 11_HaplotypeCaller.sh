#!/bin/bash
gatk ApplyBQSR \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-I alignment.RG.merged.sorted.dedup.bam \
	--bqsr-recal-file alignment.RG.merged.sorted.dedup.bqsr.table \                       
	-O alignment.RG.merged.sorted.dedup.bqsr.g.vcf

