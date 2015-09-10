library(tools)
library(rjson)
library(MASS)
library(Hmisc)
library(SparseM)
library(Matrix)
library(slam)
library(modeest)

source("./absoluteRiskCalculation.R")

sysname <- Sys.info()['sysname']

if(sysname == "Linux") {
  dyn.load("source.so")

} else if(sysname == "Windows") {
  dyn.load("source.dll")
}

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
  save(rData, file=filename)

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

  # get() returns the variable name from load(filename)

  tmp = load(filename)
  tmpvar = get(tmp)
  result = toJSON(tmpvar)
  return (result)

}


#--------------------------------------------------------------------
# Inputs: model_info with JSON format and list_of variables "RData file names"
# outputs: the model formula
#--------------------------------------------------------------------
#
# test code:
#
#
# > t1=c("list_of_variables.RData")
# > myJSON=c("[{\"name\":\"famhist\",\"linear\":true},{\"name\":\"menarche_dec\",
#            \"linear\":true},{\"name\":\"parity\",\"linear\":true},{\"name\":\"birth_dec\",
#            \"linear\":true},{\"name\":\"agemeno_dec\",\"linear\":true},{\"name\":\"height_dec\",
#            \"linear\":true},{\"name\":\"bmi_dec\",\"linear\":true,\"interaction\":\"rd_menohrt\"},
#            {\"name\":\"rd_menohrt\",\"linear\":true},{\"name\":\"rd2_everhrt_e\",\"linear\":true},
#            {\"name\":\"rd2_everhrt_c\",\"linear\":true},{\"name\":\"rd2_currhrt\",\"linear\":true},
#            {\"name\":\"alcoholdweek_dec\",\"linear\":true},{\"name\":\"ever_smoke\",\"linear\":true}])
#
# > model_predictor = create_formula(myJSON,t1)
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

form_type<-function(var_name, model_info, list_of_variables){

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
# Note: R function to handle the upload of a CSV file
# Inputs: the input file name has the extension of csv
# Outputs: return the corresponding RData filename with the extension ".RData"
#--------------------------------------------------------
#
# Test Code:
#
# > uploadCSV("cov_new.csv")
#     [1] "cov_new.RData"
# > test=uploadCSV("cov_new.csv")
# > test
#     [1] "cov_new.RData"
# > load(test)
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
  # mydata = read.table(filename, header = TRUE, sep = ",",  as.is = TRUE)

  mydata <- read.csv(filename, sep=",",header=TRUE,stringsAsFactor=FALSE)

  baseFileName = file_path_sans_ext(filename)
  convertedFileName = file_path_sans_ext(convertedFilePath)

  varName = basename(baseFileName)
  assign(varName,mydata)
  rdataFileName = paste(convertedFileName,".RData",sep="")
  save(list=varName, file=rdataFileName)

  return (rdataFileName)
}


#------------------------------------------
# Function: File to generate the names of log odds rates (aka "beta_given")
# Inputs: (1) RData file name for list_of_variables (e.g.list_of_variables.RData") and
#         (2) RData file name for model_predictor (e.g.,"model_predictor.RData")
# Outputs: return the listnames in JSON format
#------------------------------------------
#
# Test Code:
#
# > t1=c("list_of_variables.RData")
# > t2=c("model_predictor.RData")
# > qq=log_odds_rates(t1,t2)
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

log_odds_rates <- function(list_of_variables_RData, formula_data)
{
  list_of_variables=get(load(list_of_variables_RData))

  listnames = get_beta_given_names(list_of_variables, as.formula(formula_data))
  listnamesJSON= toJSON(listnames)
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
  lambda=get(load(diseaseRDataFileName))
  model.competing.incidence.rates = check_competing_rates(csvFileName, lambda)
  baseFileName = file_path_sans_ext(csvFileName)
  convertedFileName = file_path_sans_ext(convertedFilePath)

  rdataFileName = paste(convertedFileName,".RData",sep="")
  save(model.competing.incidence.rates, file=rdataFileName)
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
  baseFileName = file_path_sans_ext(filename)
  convertedFileName = file_path_sans_ext(convertedFilePath)

  rdataFileName = paste(convertedFileName,".RData",sep="")

  save(lambda, file=rdataFileName)
  return (rdataFileName)
}

#-------------------------------------------------------
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
# > process_SNP_info("test.csv","famhist")
#
#--------------------------------------------------------

process_SNP_info <- function(filename, famHist, convertedFilePath)
{
  mydata <- read.csv(filename, sep=",",header=TRUE,stringsAsFactor=FALSE)
  baseFileName = file_path_sans_ext(filename)
  convertedFileName = file_path_sans_ext(convertedFilePath)

  varName = basename(baseFileName)
  assign(varName,mydata)
  rdataFileName = paste(convertedFileName,".RData",sep="")
  save(list=varName, file=rdataFileName)

  save(famHist, file="famHist.RData")

  return (rdataFileName)
}

#----------------------------------------------------
# Name: process_age_code.R
# Function: check the age inputs
#
# Inputs: 6 RData file names. Examples:
#    (1) age_start_RData="age_new.RData"
#    (2) age_interval_RData="tau.RData"
#    (3) cov_new_RData="cov_new.RData"
#    (4) snp_info_RData="snp_info.RData"
#    (5) disease_rates_RData="pop_rates.RData"
#    (6) competing_rates_RData="mort_rates_default_US.RData"

# outputs: "NULL" if no errors.
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

process_age_code <- function(ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_start_RData, age_interval_RData, cov_new_RData, disease_rates_RData, competing_rates_RData, genotype_new_RData)
{
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
    jpeg('rplot.jpg', width = 9, height = 9, units = 'in', res = 600)
    par(mfrow=c(3,4))
    for(i in 1:length(results$risk)){
      plot(density(results$refs.risk, na.rm=T), main=paste("Subject ", i, sep=""), ylab = "Smoothed Frequency Density", xlab="Absolute Risk", lwd=2)
      lines(abline(v=results$risk[i], col="red", lwd=2))
    }
    dev.off()
  }else{
    jpeg('rplot.jpg', width = 9, height = 9, units = 'in', res = 600)
plot(density(results$risk, na.rm=T), main="Absolute Risk Distribution", ylab = "Smoothed Frequency Density", xlab="Absolute Risk", lwd=2)
dev.off()
  }
  res = results$details
  ref = results$refs.risk
  write.csv(res , file="results.csv")
  write.csv(ref , file="results_reference.csv")
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

# outputs: "NULL" if no errors.
#----------------------------------------------------

process_age_code_helper <- function(ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_RData, cov_new_RData, disease_rates_RData, competing_rates_RData, genotype_new_RData)
{
  age <- get(load(age_RData))
  
  age_start <- age$age
  age_interval <- age$ageInterval
  
  age_start_RData <- "age_start.RData"
  age_interval_RData <- "age_interval.RData"
  
  save(age_start, file = age_start_RData)
  save(age_interval, file = age_interval_RData)
  
  process_age_code(ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_start_RData, age_interval_RData, cov_new_RData, disease_rates_RData, competing_rates_RData)
    
}
#----------------------------------------------------
# Name: process_age_code_old.R
# Function: check the age inputs
#
# Inputs: 6 RData file names. Examples:
#    (1) age_start_RData="age_new.RData"
#    (2) age_interval_RData="tau.RData"
#    (3) cov_new_RData="cov_new.RData"
#    (4) snp_info_RData="snp_info.RData"
#    (5) disease_rates_RData="pop_rates.RData"
#    (6) competing_rates_RData="mort_rates_default_US.RData"

# outputs: "NULL" if no errors.
#----------------------------------------------------
#
# Test Code
#
#  > age_start_RData="age_new.RData"
#  > age_interval_RData="tau.RData"
#  > cov_new_RData="cov_new.RData"
#  > snp_info_RData="snp_info.RData"
#  > disease_rates_RData="pop_rates.RData"
#  > competing_rates_RData="mort_rates_default_US.RData"
#  >
#  > source('H:/Rwork/MAAS/process_age_code.R')
#  > process_age_code(age_start_RData, age_interval_RData, cov_new_RData,snp_info_RData, disease_rates_RData, competing_rates_RData)
#    NULL
#
#------------------------------------------------------

# process_age_code_old <- function(age_start_RData, age_interval_RData, cov_new_RData,snp_info_RData, disease_rates_RData, competing_rates_RData)
# {
#
#   apply.age.start=get(load(age_start_RData))
#   apply.age.interval.length=get(load(age_interval_RData))
#   apply.cov.profile=get(load(cov_new_RData))
#   apply.snp.profile=get(load(snp_info_RData))
#   lambda=get(load(disease_rates_RData))
#   competing_rates=get(load(competing_rates_RData))
#
#   check_age_inputs(apply.age.start, apply.age.interval.length, apply.cov.profile, apply.snp.profile, lambda, competing_rates)
# }
