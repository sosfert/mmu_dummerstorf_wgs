#!/bin/bash

# Loop over each sample in vcf file and add missingness according to:
# DP >=4, DP < mean(DP)+3*sd(DP)

# either one of these VCFs:
in_vcf=cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS.vcf 

for samp_nm in sample_names; do
	# Extract sample from main VCF
	bcftools view \
		-s $samp_nm \
		$in_vcf \
		-o ${in_vcf/.vcf/_${samp_nm}.vcf}

	# Extract DP field
	bcftools query \
		-f '[%DP ]\n' ${in_vcf/.vcf/_${samp_nm}.vcf} \
		-o ${samp_nm}.DP

	# Calculate mean DP
	mean_DP=$(cat ${samp_nm}.DP | tr ' ' \\n | awk '{x+=$0; next} END{print x/NR}')

	# Calculate sd DP 
	sd_DP=$(cat ${samp_nm}.DP | tr ' ' \\n | awk '{sum+=$0;a[NR]=$0}END{for(i in a)y+=(a[i]-(sum/NR))^2;print sqrt(y/(NR-1))}')

	# Calculate maxDP 
	max_DP=$( echo "$mean_DP + 3*$sd_DP" | bc )

	# Add missingness to sample VCF
	vcftools --vcf ${in_vcf/.vcf/_${samp_nm}.vcf} --minGQ 20 --minDP 4 --maxDP $max_DP --recode --recode-INFO-all --out ${in_vcf/.vcf/_${samp_nm}_missingness}

	# Remove files to free space
	rm ${in_vcf/.vcf/_${samp_nm}.vcf} ${samp_nm}.DP
done

# collect sample-vcfs and add option "-V"
in_vcfs=$(ls -1 *.vcf | for i in $(cat); do echo "-V $i"; done)

# Combine variants only available for GATK3
java -Xmx1000g -jar GenomeAnalysisTK.jar \
	-T CombineVariants \
	-R Mus_musculus.GRCm38.dna.primary_assembly.fa \
	$(echo $in_vcfs) \
	-o cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.vcf

# Extract genotype information
gatk VariantsToTable \
	-V cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.vcf \
	-O cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.table \
	-F CHROM -F POS -GF GT



