#!/bin/bash
java -jar picard.jar MergeSamFiles \
	I=alignment1.RG.bam \
	I=alignment2.RG.bam \
	I=alignment3.RG.bam \
	I=... \
	O=alignment.RG.merged.bam

