#!/bin/bash

gatk_jar="/mnt/projects/esafronicheva/gatk/gatk-4.1.0.0/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"
gvcf="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/combined_vcf/new_birch_cohort.g.vcf.gz"

java -jar "$gatk_jar" IndexFeatureFile \
    -F "$gvcf"
