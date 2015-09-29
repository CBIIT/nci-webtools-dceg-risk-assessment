library(tools)
library(rjson)
library(MASS)
library(Hmisc)
library(SparseM)
library(Matrix)
library(slam)
library(modeest)
library(iCare)

source("./rfiles/absoluteRiskCalculation.R")

#-----------------------------------------
# Function: convert the JSON data to RData
# Inputs: (1) JSON data and (2) the RData file name (e.g. "test.RData)
# Outputs: the RData file with saved objects
#-----------------------------------------
#
# Test Code:
#
# > aa=toJSON(list_of_variables)
# > aa
#    [1] "[{\"name\":\"famhist\",\"type\":\"continuous\"}....
# > zz=c("test.RData")
# > convertJSONtoRData(aa, zz)
# > t1=load(zz)
# > t2=get(t1)
# > t2
#    [[1]]
#    [[1]]$name
#    [1] "famhist"
#------------------------------------------

convertJSONtoRData <- function(myJSONdata, filename) {
    rData <- fromJSON(myJSONdata)
    save(rData, file = filename)
}

#-----------------------------------------------------
# Function: handle the upload of a RData file
# Inputs: the input file name has the .RData
# Outputs: return the contents of the RData file in JSON format
#-----------------------------------------------------

# Test Code:
#
# > tmp=uploadRData("list_of_variables.RData")
# > tmp
#  [1] "[{\"name\":\"famhist\",\"type\":\"continuous\"}....
# > test=fromJSON(tmp)
# > test
# [[1]]
# [[1]]$name
# [#1] "famhist"
#------------------------------------------------------

uploadRData <- function(filename)
{
  fileData = get(load(filename)) # Load the contents of the file
  return (toJSON(fileData))
}

#--------------------------------------------------------------------
# Function: Generates a model formula and returns it as a string
# Inputs: (1) model_info as JSON and (2) list_of_variables as RData
# outputs: the model formula (character string)
#--------------------------------------------------------------------
#
# test code:
#
#
# > t1 = "list_of_variables.RData"
# > myJSON="[{\"name\":\"famhist\",\"linear\":true},{\"name\":\"menarche_dec\",
#            \"linear\":true},{\"name\":\"parity\",\"linear\":true},{\"name\":\"birth_dec\",
#            \"linear\":true},{\"name\":\"agemeno_dec\",\"linear\":true},{\"name\":\"height_dec\",
#            \"linear\":true},{\"name\":\"bmi_dec\",\"linear\":true,\"interaction\":\"rd_menohrt\"},
#            {\"name\":\"rd_menohrt\",\"linear\":true},{\"name\":\"rd2_everhrt_e\",\"linear\":true},
#            {\"name\":\"rd2_everhrt_c\",\"linear\":true},{\"name\":\"rd2_currhrt\",\"linear\":true},
#            {\"name\":\"alcoholdweek_dec\",\"linear\":true},{\"name\":\"ever_smoke\",\"linear\":true}]"
#
# > model_predictor = create_formula(myJSON, t1)
# > model_predictor
# [1] "Y ~ famhist + as.factor(menarche_dec) + as.factor(parity) + as.factor(birth_dec) +
#      as.factor(agemeno_dec) + as.factor(height_dec) + as.factor(bmi_dec) + as.factor(rd_menohrt) +
#      rd2_everhrt_e + rd2_everhrt_c + rd2_currhrt + as.factor(alcoholdweek_dec) +
#      as.factor(ever_smoke) + as.factor(bmi_dec)*as.factor(rd_menohrt)"
#
# > save(model_predictor, file="model_predictor.RData")
#----------------------------------------------------------------------


create_formula <- function(model_info_JSON, list_of_variables_RData) {

  # model_info=get(load(model_info_RData))

  model_info <- fromJSON(model_info_JSON)
  list_of_variables=get(load(list_of_variables_RData))

  # initialize
  form = "Y ~ "
  inter = " "
  # add linear terms, collect interactions
  for(i in 1:length(model_info)){

    # if linear term
    if(model_info[[i]]$linear){
      if(i!=1){
        form = paste(form, " + ", sep="")
      }
      if(list_of_variables[[i]]$type=="factor"){
        form = paste(form, "as.factor(", model_info[[i]]$name ,")", sep="")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
            inter = paste(inter, "+ as.factor(", model_info[[i]]$name ,")*", sep="")
            inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep="")
          }
        }
      }else{
        form = paste(form, model_info[[i]]$name , sep="")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
            inter = paste(inter,"+ " , model_info[[i]]$name , "*", sep="")
            inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep="")
          }
        }
      }
    }
  }
  # add interaction terms
  form = paste(form, inter, sep="")
  return (form)
}

form_type <- function(var_name, model_info, list_of_variables){

  for(j in 1:length(list_of_variables)){
    if(var_name == list_of_variables[[j]]$name){
      i = j; break
    }
  }
  if(list_of_variables[[i]]$type=="factor"){
    res = paste("as.factor(", model_info[[i]]$name ,")", sep="")
  }else{
    res = model_info[[i]]$name
  }
  res
}

#-------------------------------------------------------
# Function: Converts an uploaded csv file to an RData file and returns the path
# Inputs: (1) The input file name (*.csv) and
#         (2) The path to the output file, without the file extension
# Outputs: Returns the corresponding RData filename with the extension ".RData"
#--------------------------------------------------------
#
# Test Code:
#
# > test=uploadCSV("cov_new.csv")
# > test
#     [1] "cov_new.RData"
# > mydata=load(test)
# > mydata
#     [1] "cov_new"
# > get(mydata)
#
#    famhist menarche_dec parity birth_dec agemeno_dec height_dec bmi_dec rd_menohrt rd2_everhrt_e rd2_everhrt_c rd2_currhrt
# 1         1            1      3         1           1         10       9          2             1             0           0
#--------------------------------------------------------

uploadCSV <- function(filename, convertedFilePath)
{
  mydata <- read.csv(filename, sep=",", header = TRUE, stringsAsFactor = FALSE)

  convertedFileName = file_path_sans_ext(convertedFilePath)
  rdataFileName = paste(convertedFileName, ".RData", sep = "")

  save(mydata, file = rdataFileName)
  return (rdataFileName)
}

#-------------------------------------------------------
# Function: Converts a two-column log_odds_rates file to an RData file and returns the path
# Inputs: (1) The input file name (*.csv) and
#         (2) The path to the output file, without the file extension
# Outputs: Returns the corresponding RData filename with the extension ".RData"
#--------------------------------------------------------

upload_log_odds <- function(csvFilePath, rDataFilePath) {
  fileContents = get(load(uploadCSV(csvFilePath, rDataFilePath)))

  rmatrix <- matrix(fileContents[[2]], ncol=1)
  rownames(rmatrix) <- fileContents$names

  rDataFilePath <- paste(rDataFilePath, ".RData", sep="")

  save(rmatrix, file=rDataFilePath)

  return (rDataFilePath)
}

#------------------------------------------
# Function: Generates the names of log odds rates (aka "beta_given")
# Inputs: (1) RData file name for list_of_variables (e.g. "list_of_variables.RData") and
#         (2) RData file name for model_predictor (e.g. "model_predictor.RData")
# Outputs: Returns the list of names as JSON
#------------------------------------------
#
# Test Code:
#
# > t1 = "list_of_variables.RData"
# > t2 = "model_predictor.RData"
# > qq = log_odds_rates(t1,t2)
# > qq
#     [1] "[\"famhist\",\"as.factor(menarche_dec)2\",\"as.factor(menarche_dec)3\",
#           \"as.factor(menarche_dec)5\"
# > aa=fromJSON(qq)
# > aa
#    [1] "famhist"                                     "as.factor(menarche_dec)2"
#    [3] "as.factor(menarche_dec)3"                    "as.factor(menarche_dec)5"
#
#-------------------------------------------
#

log_odds_rates <- function(list_of_variables_RData, model_predictor_RData)
{
  list_of_variables = get(load(list_of_variables_RData))
  #predictor = as.formula(get(load(model_predictor_RData)))
  predictor = as.formula(model_predictor_RData)
  listnames = get_beta_given_names(list_of_variables, predictor)

  listnamesJSON = toJSON(listnames)
  return (listnamesJSON)
}


#------------------------------------------
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
# disease RData: diseaseRDataFileName = "pop_rates.RData"
#
# process_competing_rates(csvFileName,diseaseRDataFileName)
#------------------------------------------

process_competing_rates <- function(csvFileName, diseaseRDataFileName, convertedFilePath)
{
  lambda = get(load(diseaseRDataFileName))
  model.competing.incidence.rates = check_competing_rates(csvFileName, lambda)

  convertedFileName = file_path_sans_ext(convertedFilePath)
  rdataFileName = paste(convertedFileName, ".RData", sep="")

  save(model.competing.incidence.rates, file = rdataFileName)
  return (rdataFileName)
}


#------------------------------------------
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

process_disease_rates <- function(filename, convertedFilePath)
{
  lambda = check_disease_rates(filename)
  lambda = na.omit(lambda)
  
  convertedFileName = file_path_sans_ext(convertedFilePath)
  rdataFileName = paste(convertedFileName, ".RData", sep = "")

  save(lambda, file = rdataFileName)
  return (rdataFileName)
}


#-------------------------------------------------------
# Function: Handles the SNP_info data sets
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
# > process_SNP_info("test.csv","famhist", "snp_info", "famhist_variable_name")
#
#--------------------------------------------------------

process_SNP_info <- function(filename, famHist, snpFilePath, famHistFilePath)
{
  mydata <- read.csv(filename, sep=",", header = TRUE, stringsAsFactor = FALSE)

  snpFileName = file_path_sans_ext(snpFilePath)
  famHistFileName = file_path_sans_ext(famHistFilePath)

  snpFileName = paste(snpFileName, ".RData",sep="")
  famHistFileName = paste(famHistFileName, ".RData",sep="")

  save(mydata, file = snpFileName)
  save(famHist, file = famHistFileName)

  return (toJSON(c(snpFileName, famHistFileName)))
}


#----------------------------------------------------
# Function: check the age inputs
#
# Inputs: 6 RData file names. Examples:
#    (1) age_start_RData="age_new.RData"
#    (2) age_interval_RData="tau.RData"
#    (3) cov_new_RData="cov_new.RData"
#    (4) snp_info_RData="snp_info.RData"
#    (5) disease_rates_RData="pop_rates.RData"
#    (6) competing_rates_RData="mort_rates_default_US.RData"

# outputs: Returns the paths to the output files in JSON format
#----------------------------------------------------
#
# Test Code
#
#  > age_start_RData="age_new.RData"
#  > age_interval_RData="tau.RData"
#  > cov_new_RData="cov_new.RData"
#  > genotype_new_RData="genotype_new.RData"
#  > disease_rates_RData="pop_rates.RData"
#  > competing_rates_RData="mort_rates_default_US.RData"
#  >
#  > fam_hist_RData="famHist.RData"
#  > snp_info_RData="snp_info.RData"
#  > list_of_variables_RData="list_of_variables.RData"
#  > model_predictor_RData="model_predictor.RData"
#  > log_odds_RData="beta_given_better.RData"
#  > ref_dataset_RData="risk_factor_distribution.RData"
#  >
#  > source('H:/Rwork/MAAS/process_age_code.R')
#  > process_age_code(age_start_RData, age_interval_RData, cov_new_RData,snp_info_RData, disease_rates_RData, competing_rates_RData)
#    NULL
#
#------------------------------------------------------

process_age_code <- function(file_path_prefix, ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_start_RData, age_interval_RData, cov_new_RData, genotype_new_RData, disease_rates_RData, competing_rates_RData)
{
  image_path <- paste(file_path_prefix, '_rplot.jpg', sep="" )
  results_path <- paste(file_path_prefix, '_results.csv', sep="")
  results_reference_path <- paste(file_path_prefix, '_results_reference.csv', sep="")

  apply.age.start=get(load(age_start_RData))
  apply.age.interval.length=get(load(age_interval_RData))
  apply.cov.profile=get(load(cov_new_RData))
  apply.snp.profile=get(load(genotype_new_RData))
  lambda=get(load(disease_rates_RData))
  competing_rates=get(load(competing_rates_RData))

  fam_hist=get(load(fam_hist_RData))
  snp_info=get(load(snp_info_RData))
  list_of_variables=get(load(list_of_variables_RData))
  model_predictor=as.formula( get(load(model_predictor_RData)) )
  log_odds=get(load(log_odds_RData))
  ref_dataset=get(load(ref_dataset_RData))

  results = compute.absolute.risk(model.formula = model_predictor, model.cov.info = list_of_variables, model.snp.info = snp_info, model.log.RR = log_odds,
                                  model.ref.dataset = ref_dataset, model.ref.dataset.weights = NULL,
                                  model.disease.incidence.rates = lambda,
                                  model.competing.incidence.rates = competing_rates,
                                  model.bin.fh.name = fam_hist, n.imp = 5,
                                  apply.age.start = apply.age.start, apply.age.interval.length = apply.age.interval.length,
                                  apply.cov.profile  = apply.cov.profile,
                                  apply.snp.profile = apply.snp.profile,
                                  use.c.code = 1,  return.lp = FALSE, return.refs.risk = TRUE)

  if(length(results$risk)<=12){
    jpeg(image_path, width = 9, height = 9, units = 'in', res = 600)
    par(mfrow=c(3,4))
    for(i in 1:length(results$risk)){
      plot(density(results$refs.risk, na.rm=T), main=paste("Subject ", i, sep=""), ylab = "Smoothed Frequency Density", xlab="Absolute Risk", lwd=2)
      lines(abline(v=results$risk[i], col="red", lwd=2))
    }
    dev.off()
  }else{
    jpeg(image_path, width = 9, height = 9, units = 'in', res = 600)
    plot(density(results$risk, na.rm=T), main="Absolute Risk Distribution", ylab = "Smoothed Frequency Density", xlab="Absolute Risk", lwd=2)
    dev.off()
  }
  res = results$details
  ref = results$refs.risk
  #write.csv(res , file="results.csv")
  #write.csv(ref , file="results_reference.csv")

  write.csv(res , file=results_path)
  write.csv(ref , file=results_reference_path)

  results = paste(image_path, results_path, results_reference_path, sep=",")
  return (results)
}

#----------------------------------------------------
# Name: process_age_code_helper.R
# Function: check the age inputs
# (merged age_start and age_interval into one parameter for use with manual form submission)
#
# Inputs: 5 RData file names. Examples:
#    (1) age_RData="age_interval.rdata"
#    (2) cov_new_RData="cov_new.RData"
#    (3) snp_info_RData="snp_info.RData"
#    (4) disease_rates_RData="pop_rates.RData"
#    (5) competing_rates_RData="mort_rates_default_US.RData"

# outputs: JSON list of output files
#----------------------------------------------------

finalCalculation <- function(file_path_prefix, ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_RData, cov_new_RData, genotype_new_RData, disease_rates_RData, competing_rates_RData)
{
  age <- get(load(age_RData))

  age_start <- age$age
  age_interval <- age$ageInterval
  #age_start_RData <- "age_start.RData"
  #age_interval_RData <- "age_interval.RData"
  
  timestamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
  age_start_RData <- paste("./uploads/rdata/", timestamp, "_age_start.RData", sep="")
  age_interval_RData <- paste("./uploads/rdata/", timestamp, "_age_interval.RData", sep="")

  save(age_start, file = age_start_RData)
  save(age_interval, file = age_interval_RData)

  return (process_age_code(file_path_prefix, ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_start_RData, age_interval_RData, cov_new_RData, genotype_new_RData, disease_rates_RData, competing_rates_RData))

}
