#!/bin/bash

# Укажите директорию с вашими файлами
input_dir="/mnt/projects/esafronicheva/diploma/betula_new/01_data/fastq/trimmed"
# Укажите директорию для сохранения отчетов
output_dir="$input_dir/fast_reports"

# Создайте директорию для отчетов, если она не существует
mkdir -p "$output_dir"

# Перейдите в директорию с файлами
cd "$input_dir" || exit

# Запустите FastQC для каждого файла в директории
for file in *.fq; do
    # Проверьте, существует ли файл
    if [[ -f "$file" ]]; then
        fastqc "$file" --outdir="$output_dir"
    else
        echo "Файл $file не найден."
    fi
done

echo "Анализ завершен. Отчеты сохранены в $output_dir."
