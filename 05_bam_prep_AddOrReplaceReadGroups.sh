#!/bin/bash
FLOWCELL=flow_cell_identifier
LANE=lane_identifier
SAMP=sample_name
java -jar picard.jar AddOrReplaceReadGroups \
	I=alignment.bam \
	O=alignment.RG.bam \
	RGID=$FLOWCELL.$LANE \
	RGLB=lib_$SAMP \
	RGPL=ILLUMINA \
	RGSM=$SAMP \
	RGPU=$FLOWCELL.$LANE.$SAMP

