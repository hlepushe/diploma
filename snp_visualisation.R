#в файле .hmp надо заменить буквы перед номером хромосомы на S и убрать # в названии колонок
data <- read.table("cuted_data_sorted.hmp.txt", header = F) 
phenotype <- read.table("phenotype_fq.txt")
colnames(phenotype)[1:2] <- c("Number", 'pheno')

snps <- subset(data, V1 %in% c("rs", "S4_1024623", "S2_27634027", "S12_20062785",
                               "S5_3580861", 'S1_32938327', 'S2_7203935'))

write_xlsx(snps, path = "snp_diploma.csv") 

#в экселе надо удалить все кроме rs и самих образцов, транспонировать, rs переименовать в Number 

readed_snp<- read.csv("snp_diploma.csv", header = T, sep = ';')

snps_ready <- readed_snp %>%
  mutate(across(everything(), ~ gsub("A", "AA", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("G", "GG", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("C", "CC", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("T", "TT", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("W", "AT", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("R", "AG", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("M", "AC", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("Y", "CT", .)))
snps_ready <- snps_ready %>%
  mutate(across(everything(), ~ gsub("N", NA, .)))

for_plot <- inner_join(snps_ready, phenotype, by = "Number")

#далее надо каждый снп прогнать отдельно, заменяя его номер в переменных

summary_S2_7203935 <- for_plot %>%
  group_by(S2_7203935, pheno) %>%
  summarise(Count = n(), .groups = 'drop')

summary_S2_7203935 <- na.omit(summary_S2_7203935)


ggplot(summary_S2_7203935, aes(x = S2_7203935, y = Count, fill = pheno)) +
  geom_bar(stat = "identity") +  
  scale_fill_viridis(discrete = TRUE, option = "D") +
  labs(title = "S2_7203935",
       x = "Genotype",
       y = "Number of Samples",
       fill = "pheno") +
  theme_minimal()   
