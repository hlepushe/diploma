This repository for my diploma. Good luck for me...

Установка Conda: 
скачать нужный файл с https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/?C=M&O=A
Затем 
``` bash 
 bash Anaconda3-2024.02-1-Linux-x86_64.sh 
```
(конда встала, но создала себе путь папок  /mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/)

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
