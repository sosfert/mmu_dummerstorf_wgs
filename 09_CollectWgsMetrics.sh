#!/bin/bash

# Collect BAM metrics after bam preparation. 
# Use it to evaluate average genome coverage and territory covered by at least N reads.

java -jar picard.jar CollectWgsMetrics \
	I=alignment.RG.merged.sorted.dedup.bam \
	O=alignment.RG.merged.sorted.dedup.CollectWgsMetrics.txt \
	R=Mus_musculus.GRCm38.dna.primary_assembly.fa


