#!/bin/bash

# Extract site annotations to decide select the most reliable variants

gatk VariantsToTable \
	-V cohort_biallelicINDELs.vcf.gz \
	-F CHROM -F POS -F FILTER -F QD -F FS -F MQ -F MQRankSum \
	-F ReadPosRankSum -F SOR -O cohort_biallelicINDELs.table

