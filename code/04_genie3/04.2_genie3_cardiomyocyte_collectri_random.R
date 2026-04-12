################################################################################
#                                                                              #
#                      RUNNING GENIE3 ON SINGLE CELL DATA                      #
#                                                                              #
################################################################################

library(GENIE3)
library(dplyr)
library(OmnipathR)

setwd("/Volumes/INTENSO/PhD/cardio_slamseq/")

# Load collectri PKN
message(">>> Loading CollecTRI")
db <- collectri()

# Get expression matrix
message(">>> Loading and processing expression data")
exprMatr <- readRDS("data/External/Cardiomyocytes.Test8Merged.NoMT.All.All.Integrated.RawCountMat.rds")

# Filter expression matrix: keep genes with at least 1 UMI in more than 10 cells (smallest adult cluster is 11 cells).
exprMatr <- as.matrix(exprMatr)
keep <- apply(exprMatr, 1, function(x) x > 1) # Check cells with at least 1 umi
keep <- t(keep) # Genes as rows and samples as columns
keep <- rowSums(keep) > 10
exprMatr <- exprMatr[keep,]
genes <- rownames(exprMatr)

# Get log-normalized expression matrix of filtered genes
exprMatNorm <- readRDS("data/External/Cardiomyocytes.Test8Merged.NoMT.All.All.Integrated.LogNormCountMat.rds")
exprMatNorm <- as.matrix(exprMatNorm)
exprMatNorm <- exprMatNorm[genes,]

# Prepare collectri db in the GENIE3 format
message(">>> Preparing CollecTRI for GENIE3")
targets <- unique(db$target_genesymbol) 
targets <- intersect(targets, rownames(exprMatNorm)) # Only consider genes with enough counts.
TFs <- unique(db$source_genesymbol)
TFs <- intersect(TFs, rownames(exprMatNorm)) # Only consider TF with enough counts

# Prepare list of target and its TFs.
regulatorsList <- vector(mode = "list", length = length(targets))
names(regulatorsList) <- targets

for(i in 1:length(regulatorsList)){
  tgene <- names(regulatorsList)[i]
  regulators <- db %>% filter(target_genesymbol == tgene) %>% pull(source_genesymbol) %>% as.character()
  regulators <- intersect(regulators, TFs)
  regulatorsList[[i]] <- regulators
}

# Further filtering of expression matrix: remove genes that are not candidate variables for the model.
genes <- unique(c(unlist(regulatorsList), names(regulatorsList)))
exprMatFil <- exprMatNorm[genes,]
exprMatFil <- as.matrix(exprMatFil)

# Clean-up
message(">>> Doing a quick clean up")
rm(exprMatr, exprMatNorm, targets, regulators, genes, db)
gc()

# Run GENIE3 on a random network /randomize expression matrix? to get p-value distribution.
message(">>> Running GENIE3")
set.seed(123)
seeds <-  round(runif(n = 100, min = 100, max = 999)) # Set seed for reproducibility but achieve variability due to random initialization.
iteration <- 1
for(seed in seeds){
  set.seed(seed)
  
  # Randomize genes in exprMatFil
  genes <- sample(1:length(rownames(exprMatFil)))
  rownames(exprMatFil) <- rownames(exprMatFil)[genes]
  
  # Run GENIE3
  print(paste0("Running randomized GENIE3 iteration ", iteration, "/100 (", Sys.time(), ")"))
  weightMat <- GENIE3(exprMatrix = exprMatFil, nCores = 5, regulators = regulatorsList, targets = names(regulatorsList), returnMatrix = TRUE)
  if(iteration == 1){
    linkList <- getLinkList(weightMat)
  }else{
    newWeights <- getLinkList(weightMat)
    linkList <- merge(linkList, newWeights, by = c("regulatoryGene", "targetGene"))
  }
  iteration <- iteration + 1
  gc()
}

# Average link weight dataframe.
message(">>> Saving results")
avgLinkWeight <- data.frame(regulatoryGene = linkList$regulatoryGene,
                            targetGene = linkList$targetGene,
                            avgWeight = rowMeans(linkList[, 3:ncol(linkList)]))

saveRDS(avgLinkWeight, "results/04_genie3/genie3_avg_weight_random_net.rds")
saveRDS(linkList, "results/04_genie3/genie3_real_weights_random_net.rds")

message(">>> DONE")

