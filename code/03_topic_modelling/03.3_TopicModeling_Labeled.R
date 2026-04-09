################################################################################
#                                                                              #
#                       TOPIC MODELING FOR LABELED READS                       #
#                                                                              #
################################################################################

# Author: Inés Rivero-García.
# Date of creation: 2024-0-29
# Date of last modification: 2026-04-09

# Load libraries and set working path
setwd("/Volumes/INTENSO/PhD/cardio_slamseq/")

library(Matrix)
library(fastTopics)
library(dplyr)
library(ggplot2)

set.seed(1)

# Load data
data <- read.csv("data/GRAND-SLAM/cardio_slamseq_experiment.tsv", header = TRUE, sep = "\t")

sampleinfo <- c("ERBB2", "ERBB2", "GFP", "GFP", "GFP", "GFP", "GFP", "GFP",
                "MYC", "MYC", "MYC", "YAP5SA", "YAP5SA", "YAP5SA")

yap.DEG <- read.csv("results/02_degs/YAP5SA_vs_GFP/YAP5SA_vs_GFP_degs_lfcShrinkage_labeled.tsv", header = TRUE, sep = "\t")
erbb2.DEG <- read.csv("results/02_degs/MYC_vs_GFP/MYC_vs_GFP_degs_lfcShrinkage_labeled.tsv", header = TRUE, sep = "\t")
myc.DEG <- read.csv("results/02_degs/caERBB2_vs_GFP/caERBB2_vs_GFP_degs_lfcShrinkage_labeled.tsv", header = TRUE, sep = "\t")

yap.DEG <- yap.DEG %>% filter(padj < 0.1) %>% pull(Symbol)
erbb2.DEG <- erbb2.DEG %>% filter(padj < 0.1) %>% pull(Symbol)
myc.DEG <- myc.DEG %>% filter(padj < 0.1) %>% pull(Symbol)

degs <- unique(c(yap.DEG, erbb2.DEG, myc.DEG))

# Clean data to make it a little smaller and separate between total and labeled counts
total <- data %>%
  dplyr::select(Gene, Symbol, ERBB2_1.Readcount, ERBB2_2.Readcount, ERBB2_3.Readcount, GFP_1.1.Readcount, GFP_1.2.Readcount, GFP_1.3.Readcount, GFP_2.1.Readcount, GFP_2.2.Readcount, GFP_2.3.Readcount,
                MYC_1.Readcount, MYC_2.Readcount, MYC_3.Readcount, YAP_1.Readcount, YAP_2.Readcount, YAP_3.Readcount)
labeled <- total
NTR <- data %>%
  dplyr::select(ERBB2_1.MAP, ERBB2_2.MAP, ERBB2_3.MAP, GFP_1.1.MAP, GFP_1.2.MAP, GFP_1.3.MAP, GFP_2.1.MAP, GFP_2.2.MAP, GFP_2.3.MAP, MYC_1.MAP, MYC_2.MAP, MYC_3.MAP, YAP_1.MAP, YAP_2.MAP, YAP_3.MAP)

# Labeled counts = raw counts * median new-to-old ratio
labeled[, 3:ncol(labeled)] <- round(labeled[, 3:ncol(labeled)] * NTR)

# Remove rows with unmeasured NTRs
labeled <- labeled[complete.cases(labeled), ]

# Collapse to gene symbol for interpretability
labeled <- labeled %>%
  group_by(Symbol) %>%
  summarise(
    Gene = dplyr::first(Gene),
    across(where(is.numeric), sum),
    .groups = "drop"
  )
labeled <- as.data.frame(labeled)
rownames(labeled) <- labeled$Symbol
labeled <- labeled %>% filter(Symbol != "", !is.na(Symbol))

# Remove column with gene symbols and ensembl IDs
labeled <- labeled[, 3:ncol(labeled)] 

# Filter matrix to keep DEGs. There's 4 DEGs that do not appear in the processed matrix with all samples because they had missing MAP values for some samples from other conditions.
keep <- intersect(degs, rownames(labeled))
labeled <- labeled[keep,]

# Transform matrix for compatibility with fastTopics
labeled <- t(as.matrix(labeled))

# Fix rownames
rownames(labeled) <- sub(pattern = ".Readcount", replacement = "", x = rownames(labeled))

# Testing topic K. We fit topics with k 2-6.
fit.list <- vector(mode = "list", length = 5)
for(i in 1:5){
  k_value <- i + 1
  fit.list[[i]] <- fit_topic_model(labeled, k=k_value, numiter.main = 500, numiter.refine = 500)
  names(fit.list)[i] <- paste0("k", k_value)
}

# Check model convergence
for(i in 1:5){
  pdf(paste0("figures/03_topic_modelling/model_covergence_", names(fit.list)[i], "_labeled.pdf"), height = 3, width = 3)
  print(plot_progress(fit.list[[i]], x = "iter", add.point.every = 10, colors = "black") + 
  ggtitle(names(fit.list)[i]) +
  theme(legend.position = "none"))
  dev.off()
}

# Differential expression analysis
de.list <- vector(mode = "list", length = 5)
for(i in 1:5){
  k_value <- i + 1
  de.list[[i]] <- de_analysis(fit.list[[i]], labeled, pseudocount = 0.1, control = list(ns = 1e4, nc = 1))
  names(de.list)[i] <- paste0("k", k_value)
}


# Save topics and differential expression
for(i in 1:5){
  saveRDS(fit.list[[i]], paste0("results/03_topic_modelling/topic_model_", names(fit.list)[i], "_labeled.rds"))
  saveRDS(de.list[[i]], paste0("results/03_topic_modelling/topic_degs_", names(de.list)[i], "_labeled.rds"))
}
