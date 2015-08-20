
#------------------------------------------
# Name: process_competing_rates.R
# Function: read 2- or 3-column csv file and generate a 2-column data (age and rates) 
# Inputs: (1) the file name
#             (a) the csv file name (2- or 3-column data)
#             (b) US or UK data
#             (c) there is no filename (i.e., "" for optional)
#         (2) the RData file name that has the lambda data from the "process_disease_rates.R")
# outputs: the RData file name that has model.disease.incidence.rates
#------------------------------------------
#
# Test Code
#
# 2-column data: csvFileName = "mort_rates_default_US.csv"
# 2-column data: csvFileName = "mort_rates_default_UK.csv"
# no filename  : csvFileName = ""
# disease RData: diseaseRDataFileName = "pop_rates.RData")
#
# 
#------------------------------------------

source("absolute_risk_code_V4.15.R")

process_competing_rates <- function(csvFileName,diseaseRDataFileName)
{ 
	lambda=get(load(diseaseRDataFileName))
	model.competing.incidence.rates = check_competing_rates(csvFileName, lambda)
	baseFileName = file_path_sans_ext(csvFileName)
 	rdataFileName = paste(baseFileName,".RData",sep="") 
        save(lambda, file=rdataFileName)
        return (rdataFileName)
}


