здесь будут команды для моей второй библиотеки
1. __тримминг__
```

```

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
   
для тримминга написан отдельный trimm.sh файл, который прикреплен в репозитории

7. __Индексирование референса__
```
bwa index $ref
```


7. __выравнивание__
   
выравнивание bwa mem, команда выравнивания в файле align.sh

8. __команды pikard__

   перед снп-коллингом необходимо обработать данные pikard, для этого выполняем 3 файла (приложены в репозитории).
   
   1 pikard_read_groups.sh
   
   2 sorting.sh
   
   3 index.sh
9. __индексирование референса перед коллингом снп__ (команды вставить свои)

    ```
samtools faidx Betula_pendula_subsp_pendula.fasta
ava -jar /mnt/projects/mtis/picard/build/libs/picard.jar CreateSequenceDictionary -R Betula_pendula_subsp_pendula.fasta -O Betula_pendula_subsp_pendula.dict
    ```

