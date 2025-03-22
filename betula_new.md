здесь будут команды для моей второй библиотеки
1. __тримминг__
```
trimmomatic SE -phred33 S_1_FKDL240122156-1A_22G5CCLT4_L1_2.fq 04_output/L1_2_SE ILLUMINACLIP:/mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/envs/Trimm/share/trimmomatic-0.39-2/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:45
```
это пример одной из многих команд, параметры менялись (PE/SE, SLIDINGWINDOW, MINLEN)

2. __проверка качества триммиинга__
```
fastqc S_1_FKDL240122156-1A_22G5CCLT4_L1_1.fq
fastqc S_1_FKDL240122156-1A_22G5CCLT4_L1_2.fq
```
тримминг с разными параметрами не дал нужного результата, всегда оставалось некоторое количество баркодов/сайтов рестрикции. 
при отрезании первых 1-15 нуклеотидов терялись баркоды. принято решение сначала демультиплексировать, а потом триммить.

3. __демультиплексирование__
   
перед началом надо создать директорию аутпута и файл баркодов, в котором схема 'баркод номер' разделена через _tab_.
```
process_radtags -f /mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/S_1_FKDL240122156-1A_22G5CCLT4_L1_1.fq 
-b /mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/barcodes_24.txt -o radtags_1/ -e hindIII -r -c -q
```
аналогичная команда для второго файла S_1_FKDL240122156-1A_22G5CCLT4_L1_2.fq

для файла1
304474863 total sequences 617303 ambiguous barcode drops (0.2%) 
275256 low quality read drops (0.1%) 1130818 ambiguous RAD-Tag drops (0.4%)
302451486 retained reads (99.3%)

для файла2
304474863 total sequences
275094186 ambiguous barcode drops (90.4%)
     3630 low quality read drops (0.0%)
 28745155 ambiguous RAD-Tag drops (9.4%)
   631892 retained reads (0.2%)

4. __Мерджинг ридов по баркодам (так нельзя, но нет слёрма и снейкмейка)__
   ```
   for file in /mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/radtags_1/*.fq; do sample_name=$(basename "$file"); cat "$file" "/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/radtags_2/$sample_name" > "merged_dumulty/m_$sample_name"; done
   ```
5. __тримминг__
   
для тримминга написан отдельный 05-trimm.sh файл, который прикреплен в репозитории

 5.1 __оценка качества после тримминга__

 запуск скрипта fastqc.sh, который поместит отчеты в папку fastqc_reports. Затем в этой папке:

 ```
multyqc *

 ```

6. __Индексирование референса__
``` bash
bwa index $ref
```

7. __выравнивание__
   
выравнивание bwa mem, команда выравнивания в файле 07-align.sh

8. __команды pikard__

   перед снп-коллингом необходимо обработать данные pikard, для этого выполняем 3 файла (приложены в репозитории).
   
   1 08.1-pikard_read_groups.sh
   
   2 08.2-sorting.sh
   
   3 08.3-index.sh
9. __индексирование референса перед коллингом снп__ 

``` bash 
samtools faidx Betula_pendula_subsp_pendula.fasta
```
плюс выполнен файл 09-ref_dict.sh 

10. __коллинг вариантов (SNP)__
выполнение файла 10-haplotype_caller.sh

11. __комбинирование и индексация__
скрипт комбинирует все 96 образцов в один vcf файл, это заняло около 15 часов при подключении к серверну (при отключении расчеты останавливались). файл 11-combine.sh

после комбинирование - индексация (файл 11.1-indexing.sh)

12. __генотипирование__
    файл 12-genotiping.sh

подсчет полученных snp 

```
bcftools view -v snps birch_biallelic.vcf.gz | wc -l
```    
итого: 2 215 016    
среднее покрытие 1 спн по всем образцам:
```
 bcftools query -f '%DP\n' birch_biallelic.vcf.gz | awk '{sum+=$1; count++} END {print "Среднее покрытие:", sum/count}'
```
Среднее покрытие: 552.476

среднее покрытие 1 снп в одном образце: 
```
vcftools --gzvcf birch_biallelic.vcf.gz --depth --out output
```
создастся файл  output.idepth, затем:
```
awk '{sum+=$3} END {print "Среднее покрытие всех индивидов:", sum/NR}' output.idepth
```
Среднее покрытие всех индивидов: 5.69776

13. __фильтрация__
    файл 13_filter1.sh

14. __ГВАС__
     установка gemma, plink2

```bash
conda install bioconda/label/cf201901::gemma
conda install bioconda::plink2
```

   plink
```
plink2 --vcf filtered_rename.vcf --make-bed --out plink2  --allow-extra-chr
plink2 --bfile plink2 --input-missing-phenotype -9 --pheno phenotype.txt --make-bed --out plink_pheno --allow-extra-chr
```
   gemma:
```
gemma -bfile plink_pheno -gk 1 -o kinship_matrix 
gemma -bfile plink_pheno -gk 2 -o kinship_matrix_2
gemma -bfile plink_pheno -lmm 4 -n 1 -o gwas_results -k ./output/kinship_matrix.cXX.txt
```



