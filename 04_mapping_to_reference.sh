#!/bin/bash
bwa mem -t 64 -M Mus_musculus.GRCm38.dna.primary_assembly.fa.gz R1.output.paired.fastq.gz R1.output.paired.fastq.gz | samtools view -@ 64 -bS - > alignment.bam
