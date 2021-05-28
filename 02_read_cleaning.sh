#!/bin/bash
java -jar trimmomatic-0.38.jar PE -phred33 \
	R1.fastq.gz \
	R2.fastq.gz \
	R1.output.paired.fastq.gz \
	R1.output.unpaired.fastq.gz \
	R2.output.paired.fastq.gz \
	R2.output.unpaired.fastq.gz \
	ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 \
	LEADING:3 \
	TRAILING:3 \
	SLIDINGWINDOW:4:15 \
	MINLEN:36

