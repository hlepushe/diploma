#!/bin/bash

# Путь к директории с FASTQ файлами
FASTQ_DIR="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/trimmed"
# Путь к референсному геному
REFERENCE_GENOME="/mnt/projects/esafronicheva/diploma/01_data/Betula_pendula_subsp_pendula.fasta"
# Путь к директории для сохранения BAM файлов
OUTPUT_DIR="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/aligned"

# Создание выходной директории, если она не существует
mkdir -p "$OUTPUT_DIR"

# Переход в директорию с FASTQ файлами
cd "$FASTQ_DIR" || exit

# Цикл по всем файлам, начинающимся с 'm_'
for file in m_*; do
    # Извлечение имени образца (без расширения)
    sample_name="${file##m_}"
    
    # Выполнение выравнивания с помощью bwa mem
    bwa mem -M -t 8 "$REFERENCE_GENOME" "$file" | samtools view -Sb - > "${OUTPUT_DIR}/${sample_name}.bam"
done

echo "Выравнивание завершено!"
