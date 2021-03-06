# ---- code5 ----
# Generating principal components for modeling

source("globals.R")

# load data created in previous snippets
load(working.data.fname(4))

library(SNPRelate)                      # LD pruning, PCA

# Read in gds file for SNPRelate functions
genofile <- snpgdsOpen(gwas.fn$gds, readonly = TRUE)

# ---- code5-a ----
# Set LD threshold to 0.2
ld.thresh <- 0.2

set.seed(1000)
geno.sample.ids <- rownames(genotype)
snpSUB <- snpgdsLDpruning(genofile, ld.threshold = ld.thresh,
                          sample.id = geno.sample.ids, # Only analyze the filtered samples
                          snp.id = colnames(genotype)) # Only analyze the filtered SNPs
snpset.pca <- unlist(snpSUB, use.names=FALSE)
cat(length(snpset.pca),"\n")  #72578 SNPs will be used in PCA analysis

pca <- snpgdsPCA(genofile, sample.id = geno.sample.ids,  snp.id = snpset.pca, num.thread=1)

# Find and record first 10 principal components
# pcs will be a N:10 matrix.  Each column is a principal component.
pcs <- data.frame(FamID = pca$sample.id, pca$eigenvect[,1 : 10],
                  stringsAsFactors = FALSE)
colnames(pcs)[2:11]<-paste("pc", 1:10, sep = "")

print(head(pcs))

# ---- code5-end ----

# Close GDS file
closefn.gds(genofile)

# Store pcs for future reference with the rest of the derived data
save(genotype, genoBim, clinical, pcs, file=working.data.fname(5))
