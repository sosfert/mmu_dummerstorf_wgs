#!/bin/bash

out_vcf=cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.vcf

gatk SelectVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	-V cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.vcf \
	-L keep_snps_DU6_12_REST_15.intervals \
	-O ${out_vcf/.vcf/.TMP.vcf}


# some sites could loose the ALT allele after adding missingness. Keep sites having at least one ALT allele count
bcftools view -i 'COUNT(GT="AA")>=1 || COUNT(GT="het")>=1' ${out_vcf/.vcf/.TMP.vcf} -o $out_vcf

rm ${out_vcf/.vcf/.TMP.vcf}

