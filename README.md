This repository for my diploma. Good luck for me...

Установка Conda: 
скачать нужный файл с https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/?C=M&O=A

Затем 
``` bash 
 bash Anaconda3-2024.02-1-Linux-x86_64.sh 
```
При установке указать YES на вопрос о конфигурации, иначе не будет работать и надо прописывать пути вручную. Можно указать свой путь для установки в соответствующем вопросе. (конда встала, но создала себе путь папок  /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/ при указании пути при установке "mnt/projects/esafronicheva/anaconda_new")

Установка FastQC:
``` bash 
 conda install bioconda::fastqc  
```
сырые риды скачала и перекинула через FileZilla в папку 01_data

запуск fastQC в отдельном окружении "FastQC":
```bash
conda activate FastQC
fastqc <название файла>.fq
```
Прогнала все файлы сырых ридов (4 шт). 
установка триммоматик в отдельное окружение:
```
conda create -n Trimm
conda activate Trimm
conda install bioconda::trimmomatic
```
запуск trimmomatic

```
trimmomatic PE -phred33 01_data/S_1_EKDL240005957-1A_227F5WLT4_L7_1.fq 01_data/S_1_EKDL240005957-1A_227F5WLT4_L7_2.fq 04_output/paired_1 04_output/unpaired_1 04_output/paired_2 04_output/unpaired_2 ILLUMINACLIP:/mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/envs/Trimm/share/trimmomatic-0.39-2/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
где схема команды: trimmomatic PE (парные чтения) <инпут1> <инпут2> <аутпут1> <аутпут2> <аутпут3> <аутпут4> /путь/до/адаптера/ :дополнительные функции

парные чтения выровняли только 50%, запуск как сингл эенд риды:
``` bash
trimmomatic SE -phred33 01_data/S_1_EKDL240005957-1A_227F5WLT4_L7_1.fq 04_output/L7_trimm_SE ILLUMINACLIP:/mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/envs/Trimm/share/trimmomatic-0.39-2/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
файл L4: Input Reads: 218703211 Surviving: 215915204 (98.73%) Dropped: 2788007 (1.27%)
файл L7: Input Reads: 25531243 Surviving: 25263663 (98.95%) Dropped: 267580 (1.05%)

демультиплексинг:
установка 
```
conda create -n stacks
conda activate stacks
conda install bioconda::stacks
```
запуск как сингл-энд файла. перед запуском надо создать директорию аутпута. 
```
process_radtags -f /mnt/projects/esafronicheva/diploma/04_output/L7_trimm_SE -b /mnt/projects/esafronicheva/diploma/01_data/barcodes.txt -o radtags_L7/ -e hindIII -r -c -q
```
для L7:
25263663 total sequences
  921530 ambiguous barcode drops (3.6%)
  359369 low quality read drops (1.4%)
  272088 ambiguous RAD-Tag drops (1.1%)
23710676 retained reads (93.9%)

для L4:
215915204 total sequences
  3660461 ambiguous barcode drops (1.7%)
    56696 low quality read drops (0.0%)
  1996508 ambiguous RAD-Tag drops (0.9%)
210201539 retained reads (97.4%)

установка и запуск индексации референса с помощью bwa 

```
conda install bioconda::bwa
bwa index Betula_pendula_subsp_pendula.fasta
```




