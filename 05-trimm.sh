#!/bin/bash

# Укажите директорию с вашими файлами
input_dir="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/merged_dumulty"  # Замените на путь к вашим файлам
output_dir="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/trimmed"

# Создайте директорию для обрезанных файлов, если она не существует
mkdir -p "$output_dir"

# Путь к файлу адаптеров
adapter_file="/mnt/projects/esafronicheva/mnt/projects/esafronicheva/anaconda_new/envs/Trimm/share/trimmomatic-0.39-2/adapters/TruSeq3-SE.fa"

# Перейдите в директорию с файлами
cd "$input_dir" || exit

# Запустите Trimmomatic для каждого файла в директории
for file in *.fq; do
    # Проверьте, существует ли файл
    if [[ -f "$file" ]]; then
        # Получите имя файла без расширения
        base_name=$(basename "$file" .fq)

        # Запустите Trimmomatic
         trimmomatic SE -phred33 "$file" "$output_dir/${base_name}_trimmed.fq" \
            ILLUMINACLIP:"$adapter_file":2:30:10 HEADCROP:6 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:45
        echo "Файл $file обработан и сохранен как ${base_name}_trimmed.fq."
    else
        echo "Файл $file не найден."
    fi
done

echo "Анализ завершен. Обрезанные файлы сохранены в $output_dir."
