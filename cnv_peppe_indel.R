#set working directory to where results of cnogpro are located
setwd("results_cnogpro_indepth/")

#import cnogpro results with and without using hmm
temp1 <- list.files(pattern="*_w100.cnv")
temp2 <- list.files(pattern = "*_hmm_w100.cnv")

temp <- setdiff(temp1, temp2)

cnv_files <- lapply(temp, function(x) read.csv(x, stringsAsFactors = FALSE))
names(cnv_files) <- gsub("_w100.cnv","", temp)



cnv_df <- do.call(rbind.data.frame, cnv_files)
cnv_df$cnv <- round(cnv_df$CN_boot, digits = 0)
cnv_pos_df <- cnv_df[which(cnv_df$cnv == 2),]

#import coordinates of peppe variants and indels
peppe_coords <- as.numeric(readLines("peppe_coordinates.txt"))
indel_coords <- as.numeric(readLines("indel_coordinates.txt"))

#indentify peppe variants occuring in regions with CNVs
peppe_cnv <- vector()
cnv_w_peppe <- vector()

for (i in 1:nrow(cnv_pos_df)) {
  for (j in 1:length(peppe_coords)) {
    if (is.element(peppe_coords[j], seq(cnv_pos_df[i, "Left"],cnv_pos_df[i,"Right"],1))) {
      cnv_w_peppe[i] <- i  
      peppe_cnv[j] <- peppe_coords[j]
    }
  }
}

cnv_pos_df[na.omit(cnv_w_peppe),]

#indentify indels occuring in regions with CNVs
indel_cnv <- vector()
cnv_w_indel <- vector()

for (i in 1:nrow(cnv_pos_df)) {
  for (j in 1:length(indel_coords)) {
    if (is.element(indel_coords[j], seq(cnv_pos_df[i, "Left"],cnv_pos_df[i,"Right"],1))) {
      cnv_w_indel[i] <- i  
      indel_cnv[j] <- indel_coords[j]
    }
  }
}
