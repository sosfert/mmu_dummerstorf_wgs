#!/bin/bash
java -jar picard.jar SortSam \
	I=alignment.RG.merged.bam \
	O=alignment.RG.merged.sorted.bam \
	SORT_ORDER=coordinate \
	TMP_DIR=tmp_dir

