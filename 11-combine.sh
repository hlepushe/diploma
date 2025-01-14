#!/bin/bash

# Reference genome and GATK jar file
ref="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta"
gatk_jar="/mnt/projects/esafronicheva/gatk/gatk-4.1.0.0/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"

# Directories
gvcf_dir="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/gvcf"
output_dir="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/combined_vcf"
output_file="$output_dir/new_birch_cohort.g.vcf.gz"

# Check if GVCF directory exists
if [ ! -d "$gvcf_dir" ]; then
    echo "Error: Directory $gvcf_dir does not exist."
    exit 1
fi

# Find all GVCF files and create --variant arguments
samples=$(find "$gvcf_dir" -name "*.g.vcf.gz" | sed 's/^/--variant /')

# Check if samples were found
if [ -z "$samples" ]; then
    echo "Error: No GVCF files found in $gvcf_dir."
    exit 1
fi

# Combine GVCF files
java -Xmx36G -jar "$gatk_jar" CombineGVCFs \
    $samples \
    -O "$output_file" \
    -R "$ref"

echo "CombineGVCFs completed successfully. Output file: $output_file"
