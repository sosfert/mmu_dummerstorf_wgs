#/bin/bash

gatk ApplyVQSR \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelicSNPs.vcf.gz \
	-O cohort_biallelicSNPs_VQSR95.vcf \
	-ts-filter-level 95 \
	--tranches-file cohort_biallelicSNPs.tranches \
	--recal-file cohort_biallelicSNPs.recal \
	-mode SNP

