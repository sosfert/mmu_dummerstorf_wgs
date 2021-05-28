#!/bin/bash
# For two fastq files, in parallel
fastqc -t 2 -out output_directory R1.fastq.gz R2.fastq.gz
