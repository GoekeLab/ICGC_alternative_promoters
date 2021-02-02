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
library(BSgenome.Hsapiens.UCSC.hg38) ## add fasta option to proActiv?

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
files <- sample_tab$bam
condition <- sample_tab$condition
promoterAnnotation <- promoterAnnotation.gencode.v34.subset
result <- proActiv(files = files, promoterAnnotation = promoterAnnotation,
                   genome = 'hg38', condition = condition)
result <- result[complete.cases(assays(result)$promoterCounts),]
countData <- data.frame(assays(result)$promoterCounts, rowData(result))
write.csv(countData,file = "proActiv_outputs.csv")
