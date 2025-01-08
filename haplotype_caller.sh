#!/bin/bash

# Directories and reference genome
input_folder="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/aligned_sorted"
output_folder="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/gvcf"
ref="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta"
gatk_jar="/mnt/projects/esafronicheva/gatk/gatk-4.1.0.0/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"

# Ensure output directory exists
mkdir -p "$output_folder"

# Find BAM files and process them in parallel
find "$input_folder" -name '*.bam' | parallel -j 16 "
    output_file=${output_folder}/\$(basename {} .bam).g.vcf.gz
    if [ ! -f \"\$output_file\" ]; then
        java -jar \"$gatk_jar\" HaplotypeCaller \
            --reference \"$ref\" \
            --input {} \
            --output \"\$output_file\" \
            -ERC GVCF
    else
        echo \"Skipping existing output: \$output_file\"
    fi
"
