#!/bin/bash
java -jar picard.jar MarkDuplicates \
	I=alignment.RG.merged.sorted.bam \
	O=alignment.RG.merged.sorted.dedup.bam \
	M=alignment.RG.merged.sorted.dedup.metrics.txt \
	TMP_DIR=tmp_dir

