#!/usr/bin/env Rscript

################################################
################################################
## REQUIREMENTS                               ##
################################################
################################################

## TRANSCRIPT ISOFORM DISCOVERY AND QUANTIFICATION
## - ALIGNED READS IN BAM FILE FORMAT
## - ANNOTATION GTF FILE
## - THE PACKAGES BELOW NEED TO BE AVAILABLE TO LOAD WHEN RUNNING R

################################################
################################################
## LOAD LIBRARY                               ##
################################################
################################################
library(proActiv)
library(DEXSeq)

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
args = commandArgs(trailingOnly=TRUE)

samplesheet   <- strsplit(grep('--samplesheet*', args, value = TRUE), split = '=')[[1]][[2]]
# annot_gtf      <- strsplit(grep('--annotation*', args, value = TRUE), split = '=')[[1]][[2]]

################################################
################################################
## RUN proActiv                               ##
################################################
################################################
sample_tab <- read.csv(samplesheet,header=TRUE)
files <- sample_tab$input_file
condition <- sample_tab$condition
promoterAnnotation <- promoterAnnotation.gencode.v34.subset
result <- proActiv(files = files, condition = condition,
                   promoterAnnotation = promoterAnnotation)
result <- result[complete.cases(assays(result)$promoterCounts),]
countData <- data.frame(assays(result)$promoterCounts, rowData(result))
write.table(countData, file = "proActiv_count.csv",
            sep = ",", quote = FALSE, row.names = FALSE)

################################################
################################################
## RUN DEXSeq for alternative promoter usage  ##
################################################
################################################
library(DEXSeq)
## Call DEXSeq - promoter as feature, gene as group
dxd <- DEXSeqDataSet(countData = as.matrix(countData[,seq_len(length(condition))]),
                     sampleData = data.frame(colData(result)),
                     design = formula(~ sample + exon + condition:exon),
                     featureID = as.factor(countData$promoterId),
                     groupID = as.factor(countData$geneId))
dxr1 <- DEXSeq(dxd)
dxr1 <- data.frame(dxr1[,1:10]) %>% 
  group_by(groupID) %>% 
  mutate(minp = min(padj)) %>%
  arrange(minp)
write.table(dxr1, file = "DEXSeq_alt_promoter_usage_output.csv",
            sep = ",", quote = FALSE, row.names = FALSE)
