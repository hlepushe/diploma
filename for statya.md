1. скопировать файл снипов filtered_maxmissing80.recode.vcf в папку for_statya
2. новый файл фенотипов phenotype_new.txt, где 1=bush (до 80 см), 2=high (200-250 см), 3=short (80-200 см), 4=one (более 250 см), 5=none (некарел). 
3. замена на бинарные коды для геммы: если в 3 столбце стоит 3- заменить на 1 (case), если стоит 1,2,4,5 - заменить на 2 (control)
```
 awk 'BEGIN{OFS=FS=" "} {
  if ($3 == 3) $3 = 1;
  else if ($3 == 1 || $3 == 2 || $3 == 4 || $3 == 5) $3 = 2;
  print
}' phenotype_new.txt > short_pheno.txt
```
4. создать 4 папки и переместить туда vcf и соответствующие фенотипы
5. ```
   plink2 --vcf filtered_maxmissing80.recode.vcf --make-bed --out plink2  --allow-extra-chr
   ```
   ```
   plink2 --bfile plink2 --input-missing-phenotype -9 --pheno pheno_bush.txt --make-bed --out plink_pheno --allow-extra-chr
   ```
   ```
   gemma -bfile plink_pheno -gk 1 -o kinship_matrix
   ```
   ```
   gemma -bfile plink_pheno -gk 2 -o kinship_matrix_2
   ```
   ```
   gemma -bfile plink_pheno -lmm 4 -n 1 -o gwas_results -k ./output/kinship_matrix.cXX.txt
   ```
   
