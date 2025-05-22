library(vcfR)
library(vegan)
library(ggplot2)
library(dplyr)

# 1. Загрузка VCF
snps <- read.vcfR("filter.recode.vcf")  # заменить на свой файл

# 2. Извлечение генотипов как чисел (0, 1, 2, NA)
snps_num <- vcfR::extract.gt(snps,
                             element = "GT",
                             IDtoRowNames  = FALSE,
                             as.numeric = TRUE,
                             convertNA = TRUE,
                             return.alleles = FALSE)

# 3. Транспонируем: образцы по строкам
genotypes <- t(snps_num)

# 4. (опционально) Удаляем колонки без вариабельности
genotypes <- genotypes[, apply(genotypes, 2, function(x) length(unique(na.omit(x))) > 1)]

# # 5. Заменим NA на среднее по SNP (по колонкам)
# replace_na_with_mean <- function(x) {
#   x[is.na(x)] <- mean(x, na.rm = TRUE)
#   return(x)
# }
# genotypes_filled <- apply(genotypes, 2, replace_na_with_mean)

# 6. NMDS
dist_matrix <- dist(genotypes, method = "euclidean")
nmds <- metaMDS(dist_matrix, k = 2, trymax = 100)

# 7. Получаем координаты и добавляем имена
nmds_points <- as.data.frame(nmds$points)
nmds_points$Sample <- rownames(nmds_points)

nmds_points$Sample <- gsub("\\.fq$", "", nmds_points$Sample)


# 8. Загрузка информации о популяциях
# Предположим, в файле два столбца: sample population
sample_metadata <- read.table("phenotype.txt", header = FALSE, stringsAsFactors = FALSE)
colnames(sample_metadata) <- c("Sample", "Population")

# 9. Объединяем с координатами
plot_data <- left_join(nmds_points, sample_metadata, by = "Sample")

# 10. Построение графика
ggplot(plot_data, aes(x = MDS1, y = MDS2, color = Population)) +
  geom_point(size = 3) +
  geom_text(aes(label = Sample), vjust = -0.5, size = 2.5) +
  theme_minimal() +
  labs(title = "NMDS по SNP с группами",
       x = "NMDS1", y = "NMDS2") +
  scale_color_brewer(palette = "Set1")

# 11. PERMANOVa

# Убедись, что колонка Population — это фактор
plot_data$Population <- as.factor(plot_data$Population)

# PERMANOVA
adonis_result <- adonis2(dist_matrix ~ Population, data = plot_data)

# Посмотрим результат
print(adonis_result)

# Извлекаем значения
r_squared <- round(adonis_result$R2[1], 3)
p_value <- signif(adonis_result$`Pr(>F)`[1], 3)

#новый график с пермановой
ggplot(plot_data, aes(x = MDS1, y = MDS2, color = Population)) +
  geom_point(size = 3) +
  #stat_ellipse(aes(group = Population), type = "norm", linetype = 2)+ #эллипсы
  geom_text(aes(label = Sample), vjust = -0.5, size = 2.5)+  #подписи образцов 
  theme_minimal() +
  labs(title = "NMDS по SNP с PERMANOVA",
       x = "NMDS1", y = "NMDS2") +
  scale_color_brewer(palette = "Set1") +
  annotate("text", x = Inf, y = -Inf,
           label = paste0("PERMANOVA:\nR² = ", r_squared, 
                          ", p = ", p_value),
           hjust = 1.1, vjust = -0.5, size = 4, color = "black")

