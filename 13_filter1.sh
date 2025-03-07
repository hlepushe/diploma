#!/bin/bash
#$ -l mem_free=36G
#$ -l slt=8
#$ -cwd
#########################################################

vcf_path="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq"
ref="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta"
gatk_jar="/mnt/projects/esafronicheva/gatk/gatk-4.1.0.0/gatk-4.1.0.0/gatk-package-4.1.0.0-local.jar"

# Фильтрация вариантов
java -Xmx36G -jar $gatk_jar VariantFiltration \
   -R $ref \
   -V $vcf_path/birch_biallelic.vcf.gz \
   --output $vcf_path/birch.maf0.05.filtered.vcf.gz \
   --filter-expression "MQ < 40.0" --filter-name "MQ40" \
   --filter-expression "QD < 24.0" --filter-name "QD24" \
   --filter-expression "MQRankSum < -2.0 && MQRankSum != '.'" --filter-name "MQRankSum2L" \
   --filter-expression "ReadPosRankSum < -8.0 && ReadPosRankSum != '.'" --filter-name "ReadPosRankSum-8"\
   --filter-expression "FS > 60.0" --filter-name "FS60" \
   --filter-expression "SOR > 3.0" --filter-name "SOR3" \
   --filter-expression "DP < 20.0" --filter-name "DP20" \
   --filter-expression "AF < 0.05" --filter-name "LowAF" \
   --filter-expression "AF > 0.99" --filter-name "HighAF" \
   --filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8"

# Выбор SNP с нужными фильтрами
java -Xmx36G -jar $gatk_jar SelectVariants \
   --variant $vcf_path/birch.maf0.05.filtered.vcf.gz \
   -O $vcf_path/birch.filtered.maf0.05.nocall0.5.SNP.biallelic.vcf.gz \
   -select-type SNP \
   --restrict-alleles-to BIALLELIC \
   --max-nocall-fraction 0.5 \
   --exclude-non-variants

# Выбор только прошедших фильтрацию вариантов
java -Xmx36G -jar $gatk_jar SelectVariants \
   --variant $vcf_path/birch.filtered.maf0.05.nocall0.5.SNP.biallelic.vcf.gz \
   -O $vcf_path/birch.filtered.maf0.05.nocall0.5.SNP.biallelic.selected.vcf \
   --select "vc.isNotFiltered()"

# Создание таблицы
java -Xmx36G -jar $gatk_jar VariantsToTable \
   -R $ref \
   -V $vcf_path/birch.filtered.maf0.05.nocall0.5.SNP.biallelic.selected.vcf \
   --output $vcf_path/birch.cohort.genotype.filtered.maf0.05.nocall0.5.SNP.biallelic.table \
   -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F FILTER -F MQ -F QD \
   -F MQRankSum -F FS -F SOR -F DP -F AF -F ReadPosRankSum -F InbreedingCoeff

# Подсчет количества SNP
grep -v "^#" $vcf_path/birch.filtered.maf0.05.nocall0.5.SNP.biallelic.selected.vcf | wc -l
