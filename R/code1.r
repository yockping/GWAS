# ---- code1 ----
# Reading data into R

source("globals.R")

# ---- code1-a ----
library(snpStats)                       # loading SNPs and performing QC

# Read in PLINK filesto create snpMatrix objects
geno <- read.plink(gwas.fn$bed, gwas.fn$bim, gwas.fn$fam, na.strings = ("-9"))

# ---- code1-b ----
# Obtain the genotypes table from snpMatrix objects
# Note: Phenotypes and covariates will be read from the clinical data file, below
genotype <- geno$genotype
print(genotype)                  # 861473 SNPs read in for 1401 subjects

#Obtain the SNP information table from snpMatrix objects
genoBim <- geno$map
colnames(genoBim) <- c("chr", "SNP", "gen.dist", "position", "A1", "A2")
print(head(genoBim))

# Remove raw file to open up memory
rm(geno)

# ---- code1-c ----
# Read in clinical file
clinical <- read.csv(clinical.fn,
                     colClasses=c("character", "factor", "factor", rep("numeric", 4)))
rownames(clinical) <- clinical$FamID
print(head(clinical))

# ---- code1-d ----
# Subset genotype for subject data
genotype <- genotype[clinical$FamID, ]
print(genotype)  # Tutorial: All 1401 subjects contain both clinical and genotype data

# ---- code1-end ----

# Write genotype, genoBim, clinical for future use
save(genotype, genoBim, clinical, file = working.data.fname)
