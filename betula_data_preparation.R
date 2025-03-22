library(vcfR)
library(vegan)
library(ggplot2)
library(ggpubr)

snps <- vcfR::read.vcfR("filtered_pca.recode.vcf", convertNA  = TRUE)

snps_num <- vcfR::extract.gt(snps, 
                             element = "GT",
                             IDtoRowNames  = F,
                             as.numeric = T,
                             convertNA = T,
                             return.alleles = F)
#сохраняем имена образцов
sample_names <- colnames(snps_num)

snps_num_t <- t(snps_num) 
snps_num_df <- data.frame(snps_num_t) 

find_NAs <- function(x){
  NAs_TF <- is.na(x)
  i_NA <- which(NAs_TF == TRUE)
  N_NA <- length(i_NA)
  cat("Results:",N_NA, "NAs present\n.")
  return(i_NA)
}

N_rows <- nrow(snps_num_t)

N_NA   <- rep(x = 0, times = N_rows)

N_SNPs <- ncol(snps_num_t)

for(i in 1:N_rows){
  i_NA <- find_NAs(snps_num_t[i,]) 
  N_NA_i <- length(i_NA)
  N_NA[i] <- N_NA_i
}

cutoff50 <- N_SNPs*0.5

hist(N_NA)            
abline(v = cutoff50, 
       col = 2, 
       lwd = 2, 
       lty = 2)


percent_NA <- N_NA/N_SNPs*100
i_NA_50percent <- which(percent_NA > 50) 
snps_num_t02 <- snps_num_t[-i_NA_50percent, ]

row_names <- row.names(snps_num_t02)
row_names02 <- gsub("sample_","",sample_names)

sample_id <- gsub("^([ATCG]*)(_)(.*)",
                  "\\3",
                  row_names02)

pop_id <- gsub("[01-9]*",    
               "",
               sample_id)

table(pop_id)

# invar_omit <- function(x){
#   cat("Dataframe of dim",dim(x), "processed...\n")
#   sds <- apply(x, 2, sd, na.rm = TRUE)
#   i_var0 <- which(sds == 0)
#   
#   
#   cat(length(i_var0),"columns removed\n")
#   
#   if(length(i_var0) > 0){
#     x <- x[, -i_var0]
#   }
#   
#   ## add return()  with x in it
#   return(x)                      
# }


invar_omit <- function(x){
  cat("Dataframe of dim",dim(x), "processed...\n")
  sds <- apply(x, 2, sd, na.rm = TRUE)
  i_var0 <- which(sds == 0)
  cat(length(i_var0),"columns removed\n")
  if(length(i_var0) > 0){
    x <- x[, -i_var0]
  }
  return(x)                      
}


snps_no_invar <- invar_omit(snps_num_t02) 

snps_noNAs <- snps_no_invar

#snps_noNAs <- snps_no_invar[, colSums(is.na(snps_no_invar)) == 0]


N_col <- ncol(snps_no_invar)
for(i in 1:N_col){
  
  # get the current column
  column_i <- snps_noNAs[, i]
  
  # get the mean of the current column
  mean_i <- mean(column_i, na.rm = TRUE)
  
  # get the NAs in the current column
  NAs_i <- which(is.na(column_i))
  
  # record the number of NAs
  N_NAs <- length(NAs_i)
  
  # replace the NAs in the current column
  column_i[NAs_i] <- mean_i
  
  # replace the original column with the
  ## updated columns
  snps_noNAs[, i] <- column_i
  
}

#восстанавливаем имена образцов и записываем их как было 
sample_names <- "100" , "101", "102",  "103",  "104",  "105",  "106",  "107",  "108",  "10", "110",
 "111", "112", "11",  "13", "16.fq", "17", "18", "19", "1", "23", "25", 
 "28", "29", "30", "31", "32", "33", "34", "35", "37", "40", "42",  
 "46", "47", "4",   "50", "51",  "52",   "53", "55", "56", "57"   "58.fq"  
 "5.fq"    "60.fq"   "61.fq"   "62.fq"   "64.fq"   "65.fq"   "69.fq"   "6.fq"    "71.fq"   "73.fq"   "74.fq"  
 "75.fq"   "76.fq"   "77.fq"   "78.fq"   "7.fq"    "81.fq"   "88.fq"   "89.fq"   "8.fq"    "90.fq"   "91.fq"  
 "92.fq"   "93.fq"   "95.fq"   "96.fq"   "97.fq"   "99.fq"   "9.fq"    "dg10.fq" "dg11.fq" "dg12.fq" "dg13.fq"
 "dg14.fq" "dg16.fq" "dg17.fq" "dg18.fq" "dg1.fq"  "dg20.fq" "dg21.fq" "dg22.fq" "dg23.fq" "dg24.fq" "dg2.fq" 
 "dg3.fq"  "dg5.fq"  "dg6.fq"  "dg7.fq"  "dg8.fq"  "dg9.fq"

write.csv(snps_noNAs, file = "SNPs_cleaned_4.csv",row.names = T)

write.csv(snps_noNAs, file = "SNPs_cut.csv", row.names = TRUE)





