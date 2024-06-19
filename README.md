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




