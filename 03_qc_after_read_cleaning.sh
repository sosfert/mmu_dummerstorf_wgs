#!/bin/bash
# For two fastq files, in parallel
fastqc -t 2 -out output_directory R1.output.paired.fastq.gz R2.output.paired.fastq.gz

