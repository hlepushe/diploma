#!/bin/bash

gvcf_path="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/combined_vcf"
vcf_path="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq"
ref="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta"
gatk_jar="/mnt/projects/esafronicheva/gatk/gatk-4.1.0.0/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"


java -Xmx36G -jar "$gatk_jar" GenotypeGVCFs \
   -R $ref \
   -V $gvcf_path/new_birch_cohort.g.vcf.gz \
   -O $vcf_path/birch_biallelic.vcf.gz \
   --max-alternate-alleles 2
   --annotations-to-exclude InbreedingCoeff
