#/bin/bash

gatk ApplyVQSR \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicINDELs.vcf.gz \
	-O cohort_biallelicINDELs_VQSR99.vcf \
	-ts-filter-level 99 \
	--tranches-file cohort_biallelicsINDELs.tranches \
	--recal-file cohort_biallelicINDELs.recal \
	-mode INDEL 

