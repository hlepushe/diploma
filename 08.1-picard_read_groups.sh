#!/bin/bash

# Set variables for input and output directories
INPUT_DIR=/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/aligned
OUTPUT_DIR=/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/picard1

# Loop through each BAM file in the input directory
for BAM_FILE in $INPUT_DIR/*.bam
do
  # Get the filename without the path or extension
  FILENAME=$(basename "$BAM_FILE" .bam)
  
# Set variables for read group parameters based on the filename
#  REF=/mnt/projects/mtis/01_data//mnt/projects/mtis/01_data/Betula_pendula_subsp_pendula.faa
#  RGID="$FILENAME".0
#  RGLB="$FILENAME"
#  RGPU="$FILENAME"."$REF"
#  RGSM="$FILENAME"
#  RGPL="$REF"
  
  # Run the Picard tool to add or replace read groups
  java -jar build/libs/picard.jar AddOrReplaceReadGroups \
    I="$BAM_FILE" \
    O="$OUTPUT_DIR/$FILENAME"_rg.bam \
    RGLB=lib1 \
    RGPL=illumina \
    RGPU=unit1 \
    RGSM=$FILENAME

done


