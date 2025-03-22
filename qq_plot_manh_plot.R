library(data.table)
install.packages("qqman")
library(qqman)

gemma_results <- fread("gwas_results.assoc.txt", header = TRUE)
head(gemma_results)

gemma_results$chr <- as.character(gemma_results$chr)

chrom_map <- setNames(as.character(1:14), paste0("lcl|Bpe_Chr", 1:14))

gemma_results$chr <- chrom_map[gemma_results$chr]
gemma_results$chr <- as.numeric(gemma_results$chr)

head(gemma_results)


manhattan(gemma_results, chr = "chr", bp = "ps", snp = "rs", p = "p_wald", 
          col = c("#89B9AD", "#85586F"), 
          main = "Manhattan Plot of GEMMA Result", 
          ylim = c(0, 8), cex.axis = 1.5)

qq(gemma_results$p_wald, cex.axis = 2, cex.lab = 2)
