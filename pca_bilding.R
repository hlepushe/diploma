library(vcfR)
library(vegan)
library(ggplot2)
library(ggpubr)

SNPs_cleaned <- read.csv(file = "SNPs_cut.csv")

names <- c(100,101,102,103,  104,  105,  106,  107,  108,  10,   110, 
     111,  112,  11,   13,   16,   17,   18,   19,   1,    23,   25,  
     28,   29,   30,   31,   32,   33,   34,   35,   37,   40,   42,  
     46,   47,   4,    50,   51,   52,   53,   55,   56,   57,   58,  
     5,    60,   61,   62,   64,   65,   69,   6,    71,   73,   74,  
     75,   76,   77,   78,   7,    81,   88,   89,   8,    90,   91,
     92, 93, 95, 96, 97, 99, 9, 10.1, 11.1, 12.1, 13.1, 14.1, 16.1, 17.1, 18.1,
     1.1, 20.1, 21.1, 22.1, 23.1, 24.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1)

names2 <-  c(103,  104,  105,  106,  107,  108,     110, 
  111,  112,  11,   13,   16,   17,   18,   19,   1,    23,   25,  
  28,   29,     31,   32,   33,   34,   35,   37,   40,   42,  
  46,   47,   4,    50,   51,   52,   53,   55,   56,   57,   58,  
     60,   61,   62,   64,     69,      71,   73,   74,  
  75,   76,   77,   78,   7,    81,   88,   89,      90, 93,    11.1, 12.1, 
  14.1, 16.1, 18.1,
  21.1, 23.1, 24.1, 2.1, 3.1, 4.1, 5.1,  7.1, 8.1, 9.1)

SNPs_cleaned$ X <- names2

SNPs_scaled <- scale(SNPs_cleaned)

pca_scaled <- prcomp(SNPs_scaled)

screeplot(pca_scaled, 
          ylab  = "Relative importance",
          main = "SNPs Data Analysis")

summary_out_scaled <- summary(pca_scaled)

PCA_variation <- function(pca_summary, PCs = 2){
  var_explained <- pca_summary$importance[2,1:PCs]*100
  var_explained <- round(var_explained,1)
  return(var_explained)
}

var_out <- PCA_variation(summary_out_scaled,PCs = 10)

N_columns <- ncol(SNPs_scaled)

barplot(var_out,
        main = "Percent variation Scree plot",
        ylab = "Percent variation explained")
abline(h = 1/N_columns*100, col = 2, lwd = 2)


biplot(pca_scaled)

pca_scores <- vegan::scores(pca_scaled)

#найти список образцов в таблицах с баркодами и взять оттуда 

# pop <- read.table('phenotype_no_number.txt')
# 
# pheno <- c(pop)

#pop_id <- c("bush","bush", 'high', 'bush', 'high','high', 'high', 'short', 'short', 'high', 'high','bush', 'bush', 'high', 'high', 'high',
# 'high','high','bush','high','short','bush', 'short','bush','high','bush','short', 'high','bush','short','high','short',
# 'high','short','bush','high','bush','bush','bush','high','bush','bush','short','bush','bush','bush','short','bush','bush',
# 'short','short','bush','high','bush','bush','high','short',
# 'high','high','high','short','high','high','bush','short',
# 'bush','bush','bush','high','bush','bush','bush','bush','non',
# 'non','non','non','non','non','non','non','non','non','non','non','non','non','non','non','non','non','non', 'non','non','non')

pop_id <- c( 'bush', 'high',
            'high', 'high', 'short', 'short',  
            'high','bush', 'bush', 'high','high',  'high',
            'high','high','bush','high','short',
           'bush', 'short','bush','bush',
           'short', 'high','bush','short','high',
            'short', 'high','short','bush','high',
            'bush','bush','bush','high','bush',
           'bush','short','bush','bush',
            'short','bush','bush','short',
            'high','bush','bush','high',
            'short','high','high','high','short',
            'high','high','short',
            'bush',
           'non','non',
            'non','non','non',
            'non','non',
           'non','non','non','non','non',
           'non', 'non','non')

# pca_scores2 <- data.frame(pheno,
#                           pca_scores)

pca_scores_2 <- data.frame(pop_id,
                          pca_scores)
rownames(pca_scores_2) <- names2

ggpubr::ggscatter(data = pca_scores_2,
                  y = "PC2",
                  x = "PC1",
                  color = "pop_id",
                  shape = "pop_id",
                  xlab = "PC1 (20% variation)",
                  ylab = "PC2 (2.5% variation)",
                  main = "PCA scores")



# Create the scatter plot and add labels using row names
ggscatter(data = pca_scores_2,                   
          y = "PC2",                   
          x = "PC1",                   
          color = "pop_id",                   
                             
          xlab = "PC1",                   
          ylab = "PC2",                   
          main = "PCA scores") +
  geom_text(aes(label = rownames(pca_scores_2)), 
            vjust = -0.5,   # Adjust vertical position of text
            hjust = 0.5,    # Adjust horizontal position of text
            size = 3,       # Adjust text size
            check_overlap = F)  # Avoid overlapping text



