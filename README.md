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
запуск как сингл-энд файла
```
process_radtags -f /mnt/projects/esafronicheva/diploma/04_output/L7_trimm_SE -b /mnt/projects/esafronicheva/diploma/01_data/barcodes.txt -o radtags_L7/ -e hindIII -r -c -q
```
опции комады:
```
process_radtags [-f in_file | -p in_dir [-P] [-I] | -1 pair_1 -2 pair_2] -b barcode_file -o out_dir -e enz [-c] [-q] [-r] [-t len] [-D] [-w size] [-s lim] [-h]
  f: path to the input file if processing single-end sequences.
  i: input file type, either 'bustard' for the Illumina BUSTARD format, 'bam', 'fastq' (default), or 'gzfastq' for gzipped FASTQ.
  y: output type, either 'fastq', 'gzfastq', 'fasta', or 'gzfasta' (default is to match the input file type).
  p: path to a directory of files.
  P: files contained within directory specified by '-p' are paired.
  I: specify that the paired-end reads are interleaved in single files.
  1: first input file in a set of paired-end sequences.
  2: second input file in a set of paired-end sequences.
  o: path to output the processed files.
  b: path to a file containing barcodes for this run.
  c: clean data, remove any read with an uncalled base.
  q: discard reads with low quality scores.
  r: rescue barcodes and RAD-Tags.
  t: truncate final read length to this value.
  E: specify how quality scores are encoded, 'phred33' (Illumina 1.8+, Sanger, default) or 'phred64' (Illumina 1.3 - 1.5).
  D: capture discarded reads to a file.
  w: set the size of the sliding window as a fraction of the read length, between 0 and 1 (default 0.15).
  s: set the score limit. If the average score within the sliding window drops below this value, the read is discarded (default 10).
  h: display this help messsage.

  Barcode options:
    --inline_null:   barcode is inline with sequence, occurs only on single-end read (default).
    --index_null:    barcode is provded in FASTQ header (Illumina i5 or i7 read).
    --null_index:    barcode is provded in FASTQ header (Illumina i7 read if both i5 and i7 read are provided).
    --inline_inline: barcode is inline with sequence, occurs on single and paired-end read.
    --index_index:   barcode is provded in FASTQ header (Illumina i5 and i7 reads).
    --inline_index:  barcode is inline with sequence on single-end read and occurs in FASTQ header (from either i5 or i7 read).
    --index_inline:  barcode occurs in FASTQ header (Illumina i5 or i7 read) and is inline with single-end sequence (for single-end data) on paired-end read (for paired-end data).

  Restriction enzyme options:
    -e <enz>, --renz_1 <enz>: provide the restriction enzyme used (cut site occurs on single-end read)
    --renz_2 <enz>: if a double digest was used, provide the second restriction enzyme used (cut site occurs on the paired-end read).
    Currently supported enzymes include:
      'aciI', 'ageI', 'aluI', 'apeKI', 'apoI', 'aseI', 'bamHI', 'bfaI',
      'bgIII', 'bsaHI', 'bspDI', 'bstYI', 'claI', 'csp6I', 'ddeI', 'dpnII',
      'eaeI', 'ecoRI', 'ecoRV', 'ecoT22I', 'hindIII', 'hpaII', 'kpnI', 'mluCI',
      'mseI', 'mspI', 'ncoI', 'ndeI', 'nheI', 'nlaIII', 'notI', 'nsiI',
      'pstI', 'rsaI', 'sacI', 'sau3AI', 'sbfI', 'sexAI', 'sgrAI', 'speI',
      'sphI', 'taqI', 'xbaI', or 'xhoI'
  Adapter options:
    --adapter_1 <sequence>: provide adaptor sequence that may occur on the single-end read for filtering.
    --adapter_2 <sequence>: provide adaptor sequence that may occur on the paired-read for filtering.
      --adapter_mm <mismatches>: number of mismatches allowed in the adapter sequence.

  Output options:
    --retain_header: retain unmodified FASTQ headers in the output.
    --merge: if no barcodes are specified, merge all input files into a single output file.

  Advanced options:
    --filter_illumina: discard reads that have been marked by Illumina's chastity/purity filter as failing.
    --disable_rad_check: disable checking if the RAD site is intact.
    --len_limit <limit>: specify a minimum sequence length (useful if your data has already been trimmed).
    --barcode_dist_1: the number of allowed mismatches when rescuing single-end barcodes (default 1).
    --barcode_dist_2: the number of allowed mismatches when rescuing paired-end barcodes (defaults to --barcode_dist_1).
```







