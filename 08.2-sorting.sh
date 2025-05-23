#!/bin/bash

# Set input and output directories
INPUT_DIR="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/picard1"
OUTPUT_DIR="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/aligned_sorted"
PICARD_JAR=/media/eternus1/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/pkgs/picard-3.0.0-hdfd78af_0/share/picard-3.0.0-0/picard.jar
# Loop through all BAM files in the input directory
for BAM_FILE in "$INPUT_DIR"/*.bam; do
  # Set output file name
  OUTPUT_FILE="${BAM_FILE%.*}_sorted.bam"

  # Sort the input BAM file
  java -jar "$PICARD_JAR" SortSam -I "$BAM_FILE" -O "$OUTPUT_FILE" -SO coordinate


done
