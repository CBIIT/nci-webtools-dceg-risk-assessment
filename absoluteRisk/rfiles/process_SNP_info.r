#-------------------------------------------------------
# Name: process_SNP_info
# Note: R function to handle the SNP_info data sets
# Inputs: 
#    (1) the SNP_info data in csv format
#    (2) the string of "Family History variable name"
# Outputs: 
#    (1) the RData file for SNP_info
#    (2) the RData file for "family history"
#
# Note: the default RData file name for family history is "famHist.RData"
#--------------------------------------------------------
#
# Test Code:
# > process_SNP_info("test.csv","testFamHist")
#
#--------------------------------------------------------

library(tools)

process_SNP_info <- function(filename,famHist)
{
    mydata <- read.csv(filename, sep=",",header=TRUE,stringsAsFactor=FALSE)
    baseFileName = file_path_sans_ext(filename)
		varName = basename(baseFileName)
		assign(varName,mydata)
    rdataFileName = paste(baseFileName,".RData",sep="") 
    save(list=varName, file=rdataFileName)

		save(famHist, file="famHist.RData")
                
    return (rdataFileName)
}

