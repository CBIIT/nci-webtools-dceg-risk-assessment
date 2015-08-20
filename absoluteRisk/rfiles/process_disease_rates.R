
#------------------------------------------
# Name: process_disease_rates.R
# Function: read 2- or 3-column csv file and generate a 2-column data (age and rates)
# Inputs: the csv file name
# outputs: the RData file name that has lambda (= model.disease.incidence.rates in the main code)
#------------------------------------------
#
# Test Code
#
# 2-column data: filename = "pop_rates.csv"
# 3-column data: filename = "pop_rates_rough.csv"
# check_disease_rates(filename)
#------------------------------------------

source("absolute_risk_code_V4.15.R")
library(tools)

process_disease_rates <- function(filename)
{ 
	lambda = check_disease_rates(filename)
 	baseFileName = file_path_sans_ext(filename)
	rdataFileName = paste(baseFileName,".RData",sep="") 
     
        save(lambda, file=rdataFileName)
        return (rdataFileName)
}


