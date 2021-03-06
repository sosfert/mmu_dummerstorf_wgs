### STRUCTURAL VARIATION ANALYSIS ###


# author: Lorena Derezanin
# date: 5/11/2020
# ran in conda env snakemake (v.5.28)
# dry run: snakemake -np --use-conda --cores 20 --verbose -s snakefile

###################################################################################################################

## reads mapped to mice reference genome (Mus_musculus.GRCm38) 
# 150 samples in the cohort (6 lines)
# SV callers: Smoove (Lumpy + svtools) - population call
#             Manta - individual calls
#             Whamg - individual calls

###################################################################################################################

#### prepare config file with sample IDs and relative paths(from snakefiles) to sample bam files 

# WD="$HOME/sos-fert/20_structural_variants/git/SOS-FERT_SV_analysis"

# # batch1 (remove 10 samples that have been re-sequenced in batch2)
# ls *.bam | awk -F- '{print "  " $1 ": batch1/" $0}' > $WD/config1.yaml

# # batch2 (10 re-seq samples)
# ls *.bam | awk -F. '{print "  " $1 ": batch2/" $0}' > $WD/config2.yaml

# # batch3 (remove sample: I34772-L1_S63_L003)
# ls *.bam | awk -F- '{print "  " $1 ": batch3/" $0}' > $WD/config3.yaml 

# #cat config files (add "samples:")
# cat config1.yaml config2.yaml config3.yaml >> config.yaml


#### extract gap regions/low complexity regions in ref. genome

# python scripts/generate_masked_ranges.py Mus_musculus.GRCm38.dna.primary_assembly.fa > Mus_musculus.GRCm38_output_ranges.bed


###################################################################################################################

configfile: "config.yaml"

REF="../../../reference_genome_ensembl/Mus_musculus.GRCm38.dna.primary_assembly.fa"
# GFF="../../structural_variant_annotations/Mus_musculus.GRCm38.101.chr.gff3.gz"
EXTENSIONS=["PR3_SR3.vcf", "smoove_SU5.vcf", "wham_A5.vcf"] 
MICE_LINES=["DU6", "DU6P", "DUC", "DUhLB", "DUK", "FZTDU"]


rule all:
    input:
      # expand("02_mice_lines_manta/01_results/{sample}_manta/runWorkflow.py", sample=config["samples"]),
      # expand("02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf.gz", sample=config["samples"]),
      # expand("02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf.gz.tbi", sample=config["samples"]),
      # expand("03_mice_lines_whamg/01_results/{sample}_wham.vcf", sample=config["samples"]),
      # expand("03_mice_lines_whamg/02_genotyped/{sample}_wham.genotyped.vcf", sample=config["samples"]),     
      # expand("01_mice_lines_smoove/genotyped/{sample}-smoove.merged.gt.vcf.gz", sample=config["samples"]),
        # expand("02_mice_lines_manta/02_converted/{sample}_inv.vcf", sample=config["samples"]),
        # expand("02_mice_lines_manta/03_filter_pass/{sample}_filt_pass.vcf", sample=config["samples"]),
        # expand("02_mice_lines_manta/04_GQ20/{sample}_GQ20.vcf", sample=config["samples"]),
        # expand("02_mice_lines_manta/05_read_support/{sample}_PR3_SR3.vcf", sample=config["samples"]),
        # expand("03_mice_lines_whamg/02_filtered/{sample}_wham_filtered.vcf", sample=config["samples"]),
        # expand("03_mice_lines_whamg/03_genotyped/{sample}_wham.genotyped.vcf", sample=config["samples"]),
        # expand("03_mice_lines_whamg/04_GQ20/{sample}_wham_GQ20.vcf", sample=config["samples"]),
        # expand("03_mice_lines_whamg/05_total_support/{sample}_wham_A5.vcf", sample=config["samples"]),
        # expand("01_mice_lines_smoove/02_GQ20/{sample}_smoove_GQ20.vcf", sample=config["samples"]),
        # expand("01_mice_lines_smoove/03_read_support/{sample}_smoove_SU5.vcf", sample=config["samples"]),
        # expand("04_calls_merged_per_sample/02_sorted/{sample}_srt_{ext}", sample=config["samples"], ext=EXTENSIONS),
        # expand("04_calls_merged_per_sample/03_call_sets_list/{sample}.list", sample=config["samples"]),
        # expand("04_calls_merged_per_sample/04_sample_merged_callers/{sample}_merged.vcf", sample=config["samples"]),
        # expand("04_calls_merged_per_sample/05_survivor_sample_stats/{sample}.stats", sample=config["samples"]),
        # expand("05_calls_merged_per_line/01_merged_lines/{mice_line}_merged.vcf", mice_line=MICE_LINES),
        # expand("05_calls_merged_per_line/02_merged_lines_stats/{mice_line}.stats", mice_line=MICE_LINES),
        # expand("05_calls_merged_per_line/01_merged_lines/{mice_line}_merged_int.vcf", mice_line=MICE_LINES),
        # expand("05_calls_merged_per_line/03_merged_lines_filtered/{mice_line}_filt.vcf", mice_line=MICE_LINES),
        # expand("05_calls_merged_per_line/04_merged_lines_filt_stats/{mice_line}_filt.stats", mice_line=MICE_LINES),
        "06_all_mice_lines_merged/mice_lines_all.vcf",
        "06_all_mice_lines_merged/mice_lines_all.stats"

    



###################################################################################################################


### STRUCTURAL VARIANT CALLING ### 


# smoove SV call and genotyping
rule smoove_sv_call:
    input:
      lambda wildcards: config["samples"][wildcards.sample]
    output:
      "01_mice_lines_smoove/01_results/{sample}-smoove.genotyped.vcf.gz",
      "01_mice_lines_smoove/01_results/{sample}-smoove.genotyped.vcf.gz.csi",
      "01_mice_lines_smoove/01_results/{sample}-lumpy-cmd.sh"
    log:
      "logs/smoove/01_results/{sample}.sv_call.log"
    params:
      outdir="01_mice_lines_smoove/01_results",
      bed="Mus_musculus.GRCm38_output_ranges.bed"
    conda:
      "envs/smoove.yml"
    threads: 1
    shell:
      "smoove call --outdir {params.outdir} --exclude {params.bed} --name {wildcards.sample} --fasta {REF} -p {threads} --genotype {input} 2> {log}"

# lumpy-filter removes alignments with low mapq, depth > 1000



# prep manta config
rule manta_config:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "02_mice_lines_manta/01_results/{sample}_manta/runWorkflow.py"
    log:
        "logs/manta/01_results/{sample}_config.log"
    params:
        rundir="02_mice_lines_manta/01_results/{sample}_manta"
    conda:
        "envs/manta.yml"
    shell:
        "configManta.py --bam {input} --referenceFasta {REF} --runDir {params.rundir} 2> {log}"


# manta SV call
rule manta_sv_call:
    input:
        "02_mice_lines_manta/01_results/{sample}_manta/runWorkflow.py"
    output:
        calls="02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf.gz",
        index="02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf.gz.tbi"
    log:
        "logs/manta/01_results/{sample}_sv_call.log"
    params:
        GB=100
    threads: 10
    conda:
        "envs/manta.yml"
    shell:
        "python {input} -j {threads} -g {params.GB} 2> {log}"




# whamg SV call
rule whamg_sv_call:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "03_mice_lines_whamg/01_results/{sample}_wham.vcf"
    log:
        "logs/whamg/01_results/{sample}_sv_call.log"
    params:
        chrom="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,X,Y,MT"
    threads: 5
    conda:
        "envs/whamg.yml"
    shell:
        "whamg -f {input} -a {REF} -c {params.chrom} -x {threads} > {output} 2> {log}"



###################################################################################################################


### FORMATTING AND FILTERING ###

# unzip manta calls

rule unzip_manta:
    input:
        "02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf.gz"
    output:
        "02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf"
    log:
        "logs/manta/01_results/{sample}_unzip.log"
    shell:
        "gunzip {input} 2> {log}"


# convert reciprocal inversions (some of the BND to INV) in manta calls for correct SV counts
rule convert_INVs_manta:
    input:
        "02_mice_lines_manta/01_results/{sample}_manta/results/variants/diploidSV.vcf"
    output:
        "02_mice_lines_manta/02_converted/{sample}_inv.vcf"
    log:
        "logs/manta/02_converted/{sample}_inv_convert.log"
    shell:
        "scripts/convertInversion.py scripts/samtools {REF} {input} > {output} 2> {log}"





# filter manta calls with FILTER=PASS (sample passed all the sample-level filters for this SV event)
rule filter_PASS_manta:
    input:
        "02_mice_lines_manta/02_converted/{sample}_inv.vcf"
    output:
        "02_mice_lines_manta/03_filter_pass/{sample}_filt_pass.vcf"
    log:
        "logs/manta/03_filter_pass/{sample}_filt_pass.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools view -f PASS {input} > {output} 2> {log}"


# filter out calls with genotype quality below 20

rule filter_GQ20_manta:
    input:
        "02_mice_lines_manta/03_filter_pass/{sample}_filt_pass.vcf"
    output:
        "02_mice_lines_manta/04_GQ20/{sample}_GQ20.vcf"
    log:
        "logs/manta/04_GQ20/{sample}_GQ20.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -e 'GQ<20' {input} > {output} 2> {log}"


# include sites with read support >=3

rule keep_PR_SR_manta:
    input:
        "02_mice_lines_manta/04_GQ20/{sample}_GQ20.vcf"
    output:
        "02_mice_lines_manta/05_read_support/{sample}_PR3_SR3.vcf"
    log:
        "logs/manta/05_read_support/{sample}_PR3_SR3.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -i 'PR>=3 & SR>=3' {input} > {output} 2> {log}"




### filter whamg calls before genotyping (otherwise the GQ info is lost)

# script parameters: 
  # size: filtered out calls <50bp and >2Mb
  # filter out calls with less than 4 support. reads 
  # max CW < 0.2 (BND/translocations)

rule filter_whamg:
    input:
        "03_mice_lines_whamg/01_results/{sample}_wham.vcf"
    output:
        "03_mice_lines_whamg/02_filtered/{sample}_wham_filtered.vcf"
    log:
        "logs/whamg/02_filtered/{sample}_filtered.log"
    shell:
        "cat {input} | perl scripts/filtWhamG.pl > {output} 2> {log}"


###################################################################################################################


### GENOTYPING CALLS ###

# genotype whamg calls with svtyper
rule svtyper_genotype_whamg_calls:
    input:
        vcf="03_mice_lines_whamg/02_filtered/{sample}_wham_filtered.vcf",
        bams=lambda wildcards: config["samples"][wildcards.sample]
    output:
        "03_mice_lines_whamg/03_genotyped/{sample}_wham.genotyped.vcf"
    log:
        "logs/whamg/03_genotyped/{sample}_genotyped.log"
    params:
        outdir="03_mice_lines_whamg/03_genotyped",
        num_reads=2000000 # number of reads used for library insert size estimation
    conda:
        "envs/smoove.yml"
    shell:
        "svtyper -i {input.vcf} -B {input.bams} -l {params.outdir}/{wildcards.sample}.bam.json -n {params.num_reads} --verbose > {output} 2> {log}"


# svtyper ignores INS

###################################################################################################################



# filter out calls with genotype quality below 20

rule filter_GQ20_whamg:
    input:
        "03_mice_lines_whamg/03_genotyped/{sample}_wham.genotyped.vcf"
    output:
        "03_mice_lines_whamg/04_GQ20/{sample}_wham_GQ20.vcf"
    log:
        "logs/whamg/04_GQ20/{sample}_GQ20.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -e 'GQ<20' {input} > {output} 2> {log}"




# keep calls with A=total pieces of evidence (total support, INFO field “A” in vcf), minimun A<5

rule total_support_A_whamg:
    input:
        "03_mice_lines_whamg/04_GQ20/{sample}_wham_GQ20.vcf"
    output:
        "03_mice_lines_whamg/05_total_support/{sample}_wham_A5.vcf"
    log:
        "logs/whamg/05_total_support/{sample}_A5.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -e 'INFO/A<5' {input} > {output} 2> {log}"



### filter smoove calls

rule unzip_smoove:
    input:
        "01_mice_lines_smoove/01_results/{sample}-smoove.genotyped.vcf.gz"
    output:
        "01_mice_lines_smoove/01_results/{sample}-smoove.genotyped.vcf"
    log:
        "logs/smoove/01_results/{sample}_unzip.log"
    shell:
        "gunzip {input} 2> {log}"


# filter out calls with genotype quality below 20

rule filter_GQ20_smoove:
    input:
      "01_mice_lines_smoove/01_results/{sample}-smoove.genotyped.vcf"
    output:
        "01_mice_lines_smoove/02_GQ20/{sample}_smoove_GQ20.vcf"
    log:
        "logs/smoove/02_GQ20/{sample}_GQ20.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -e 'GQ<20' {input} > {output} 2> {log}"



# filter read support SU<5

rule read_support_SU_smoove:
    input:
        "01_mice_lines_smoove/02_GQ20/{sample}_smoove_GQ20.vcf"
    output:
        "01_mice_lines_smoove/03_read_support/{sample}_smoove_SU5.vcf"
    log:
        "logs/smoove/03_read_support/{sample}_SU5.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -e 'INFO/SU<5' {input} > {output} 2> {log}"


###################################################################################################################


### MERGE CALLS PER SAMPLE and PER LINE ###

# move all sample vcf files in one dir
# smoove
# cp 01_mice_lines_smoove/03_read_support/*.vcf 04_calls_merged_per_sample/01_all_samples/
# manta
# cp 02_mice_lines_manta/05_read_support/*.vcf 04_calls_merged_per_sample/01_all_samples/
# whamg
# cp 03_mice_lines_whamg/05_total_support/*.vcf 04_calls_merged_per_sample/01_all_samples/


# sort vcf files
rule sort_vcf:
    input:        # multiple file extensions per sample ID (filtered outputs of different callers)
        expand("04_calls_merged_per_sample/01_all_samples/{sample}_{ext}", sample="{sample}", ext=EXTENSIONS)
    output:
        expand("04_calls_merged_per_sample/02_sorted/{sample}_srt_{ext}", sample="{sample}", ext=EXTENSIONS)
    log:
        expand("logs/merging/{sample}_srt_{ext}.log", sample="{sample}", ext=EXTENSIONS)
    conda:
        "envs/bcftools.yml"
    shell:
        """
        bcftools sort -Ov {input[0]} -o {output[0]} 2> {log[0]}
        bcftools sort -Ov {input[1]} -o {output[1]} 2> {log[1]}
        bcftools sort -Ov {input[2]} -o {output[2]} 2> {log[2]}
        
        """

# fails if vcf files don't have header with chr/scf info




## SURVIVOR MERGE PER SAMPLE ##

# merge SV events per sample, called by at least 2 callers

# list all SV call sets per sample 
rule list_sample_sv_call_sets:
    input:
        expand("04_calls_merged_per_sample/02_sorted/{sample}_srt_{ext}", sample="{sample}", ext=EXTENSIONS)
    output:
        "04_calls_merged_per_sample/03_call_sets_list/{sample}.list"
    log:
        "logs/merging/{sample}_list.log"
    shell:
        "ls {input} > {output} 2> {log}"



# merge SVs with start/end within 1000 bp, called by at least 2 callers, same SV type, min.size 50 bp

rule survivor_merge:
    input:
        "04_calls_merged_per_sample/03_call_sets_list/{sample}.list"
    output:
        "04_calls_merged_per_sample/04_sample_merged_callers/{sample}_merged.vcf"
    log:
        "logs/merging/{sample}_surv.log"
    params:
        "1000 2 1 0 0 50"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR merge {input} {params} {output} 2> {log}"


# run stats per sample
rule survivor_sample_stats:
    input:
        "04_calls_merged_per_sample/04_sample_merged_callers/{sample}_merged.vcf"
    output:
        "04_calls_merged_per_sample/05_survivor_sample_stats/{sample}.stats"
    log:
        "logs/merging/{sample}_stats.log"
    params:
        "50 -1 -1"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR stats {input} {params} {output} 2> {log}"



## SURVIVOR MERGE PER LINE ##

# split samples per mice line
# prepare list of samples for each line

# merge samples per line, SV start/end within 1000 bp
rule merge_per_mice_line:
    input:
        expand("05_calls_merged_per_line/{mice_line}/{mice_line}.list", mice_line="{mice_line}")
    output:
        "05_calls_merged_per_line/01_merged_lines/{mice_line}_merged.vcf"
    log:
        "logs/merging_per_line/{mice_line}.log"
    params:
        "1000 0 1 0 0 50"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR merge {input} {params} {output} 2> {log}"


# mice line stats
rule mice_lines_stats:
    input:
        "05_calls_merged_per_line/01_merged_lines/{mice_line}_merged.vcf"
    output:
        "05_calls_merged_per_line/02_merged_lines_stats/{mice_line}.stats"
    log:
        "logs/merging/{mice_line}_stats.log"
    params:
        "50 -1 -1"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR stats {input} {params} {output} 2> {log}"



# Survivor writes SUPP as character instead of integer, change type in header
rule change_SUPP_type:
    input:
        "05_calls_merged_per_line/01_merged_lines/{mice_line}_merged.vcf"
    output:
        "05_calls_merged_per_line/01_merged_lines/{mice_line}_merged_int.vcf"
    log:
        "logs/merging/{mice_line}_int.log"
    shell:
        "sed -e 's/INFO=<ID=SUPP,Number=1,Type=String/INFO=<ID=SUPP,Number=1,Type=Integer/g' {input} > {output} 2> {log}"




# keep SV calls for which all 10 high cov. samples and at least 10 out of 15 of low cov. samples passed filter and merging steps

rule min_10_samples_per_line:
    input:
        "05_calls_merged_per_line/01_merged_lines/{mice_line}_merged_int.vcf"
    output:
        "05_calls_merged_per_line/03_merged_lines_filtered/{mice_line}_filt.vcf"
    log:
        "logs/merging/{mice_line}_filt.log"
    conda:
        "envs/bcftools.yml"
    shell:
        "bcftools filter -i 'INFO/SUPP>=10' {input} > {output} 2> {log}"



# run stats
rule min_10_samples_stats:
    input:
        "05_calls_merged_per_line/03_merged_lines_filtered/{mice_line}_filt.vcf"
    output:
        "05_calls_merged_per_line/04_merged_lines_filt_stats/{mice_line}_filt.stats"
    log:
        "logs/merging/{mice_line}_filt_stats.log"
    params:
        "50 -1 -1"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR stats {input} {params} {output} 2> {log}"
  
    
# merge lines to check for unique/shared SVs among all lines

# prep list of merged mice line vcf files

rule merge_mice_lines:
    input:
        "05_calls_merged_per_line/03_merged_lines_filtered/mice_lines_all.list"
    output:
        "06_all_mice_lines_merged/mice_lines_all.vcf"
    log:
        "logs/final_vcf/mice_lines_all.log"
    params:
        "1000 0 1 0 0 50"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR merge {input} {params} {output} 2> {log}"

# fix mice line names in the vcf files



rule all_mice_lines_stats:
    input:
        "06_all_mice_lines_merged/mice_lines_all.vcf"
    output:
        "06_all_mice_lines_merged/mice_lines_all.stats"
    log:
        "logs/merging/mice_lines_all_stats.log"
    params:
        "50 -1 -1"
    conda:
        "envs/survivor.yml"
    shell:
        "SURVIVOR stats {input} {params} {output} 2> {log}"












