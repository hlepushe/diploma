#!/bin/bash

PICARD_JAR=/media/eternus1/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/pkgs/picard-3.0.0-hdfd78af_0/share/picard-3.0.0-0/picard.jar
REF=/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.fasta
OUT=/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/ref/Betula_pendula_subsp_pendula.dict

java -jar "$PICARD_JAR" CreateSequenceDictionary -R "$REF" -O "$OUT"
