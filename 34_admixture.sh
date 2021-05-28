#!/bin/bash

FL=cohort_biallelic[SNPs,INDELs]_VQSR[95,99]_PASS_withmissingness.filtered.bed
admixture $FL 2
admixture $FL 3
admixture $FL 4
admixture $FL 5
admixture $FL 6
# Visulizations done with ggplot2, code on request.

