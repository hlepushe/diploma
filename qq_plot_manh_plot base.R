library(data.table)
library(qqman)

gemma_results <- fread("gwas_result.txt", header = TRUE)

gemma_results$chr <- as.character(gemma_results$chr)

chrom_map <- setNames(as.character(1:14), paste0("lcl|Bpe_Chr", 1:14))

gemma_results$chr <- chrom_map[gemma_results$chr]
gemma_results$chr <- as.numeric(gemma_results$chr)


qq(gemma_results$p_wald, cex.axis = 2, cex.lab = 1)

n_tests_10 <- nrow(gemma_results) 
bonf_threshold_10 <- -log10(0.05/n_tests_10)

manhattan(gemma_results,            chr = "chr",
                                    bp = "ps",
                                    snp = "rs",            
                                    p = "p_wald",                         
                                    col = c("#00aeef", "#00395d"),
                                    main = "подпись",
                                    genomewideline = F,
                                    #bonferroni_line = F,
                                    ylim = c(0,10),
                                    cex.axis = 1.5,
                                    abline(h = bonf_threshold_10, col = "red"))
 




