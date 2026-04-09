################################################################################
#                                                                              #
#                       TOPIC MODELING FOR TOTAL READS                         #
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

yap.DEG <- read.csv("results/02_degs/YAP5SA_vs_GFP/YAP5SA_vs_GFP_degs_lfcShrinkage_total.tsv", header = TRUE, sep = "\t")
erbb2.DEG <- read.csv("results/02_degs/MYC_vs_GFP/MYC_vs_GFP_degs_lfcShrinkage_total.tsv", header = TRUE, sep = "\t")
myc.DEG <- read.csv("results/02_degs/caERBB2_vs_GFP/caERBB2_vs_GFP_degs_lfcShrinkage_total.tsv", header = TRUE, sep = "\t")

yap.DEG <- yap.DEG %>% filter(padj < 0.1) %>% pull(Symbol)
erbb2.DEG <- erbb2.DEG %>% filter(padj < 0.1) %>% pull(Symbol)
myc.DEG <- myc.DEG %>% filter(padj < 0.1) %>% pull(Symbol)

degs <- unique(c(yap.DEG, erbb2.DEG, myc.DEG))

# Create matrix of DEGs for topic modeling
total <- data %>%
  dplyr::select(ends_with(c("Symbol","Gene", ".Readcount"))) %>%
  group_by(Symbol) %>%
  summarise(Gene = dplyr::first(Gene), across(where(is.numeric), sum), .groups = "drop") %>%
  dplyr::select(starts_with(c("Symbol", "ERBB2", "GFP", "MYC", "YAP"))) %>%
  filter(Symbol != "", !is.na(Symbol)) %>%
  as.data.frame()

# Add gene names
rownames(total) <- total$Symbol
total <- total[, -1] # Remove column with gene symbols

# Filter matrix to keep DEGs
total <- total[degs,]

# Transform matrix for compatibility with fastTopics
total <- t(as.matrix(total))

# Fix rownames
rownames(total) <- sub(pattern = ".Readcount", replacement = "", x = rownames(total))

# Testing topic K. We fit topics with k 2-6.
fit.list <- vector(mode = "list", length = 5)
for(i in 1:5){
  k_value <- i + 1
  fit.list[[i]] <- fit_topic_model(total, k=k_value, numiter.main = 500, numiter.refine = 500)
  names(fit.list)[i] <- paste0("k", k_value)
}

# Check model convergence
for(i in 1:5){
  pdf(paste0("figures/03_topic_modelling/model_covergence_", names(fit.list)[i], "_total.pdf"), height = 3, width = 3)
  print(plot_progress(fit.list[[i]], x = "iter", add.point.every = 10, colors = "black") + 
  ggtitle(names(fit.list)[i]) +
  theme(legend.position = "none"))
  dev.off()
}

# Differential expression analysis
de.list <- vector(mode = "list", length = 5)
for(i in 1:5){
  k_value <- i + 1
  de.list[[i]] <- de_analysis(fit.list[[i]], total, pseudocount = 0.1, control = list(ns = 1e4, nc = 1))
  names(de.list)[i] <- paste0("k", k_value)
}


# Save topics and differential expression
for(i in 1:5){
  saveRDS(fit.list[[i]], paste0("results/03_topic_modelling/topic_model_", names(fit.list)[i], "_total.rds"))
  saveRDS(de.list[[i]], paste0("results/03_topic_modelling/topic_degs_", names(de.list)[i], "_total.rds"))
}
