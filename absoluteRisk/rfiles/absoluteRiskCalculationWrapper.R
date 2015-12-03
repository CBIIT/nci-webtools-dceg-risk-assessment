library(rjson)
library(iCare)

#-------------------------------------------------------
# convertJSONtoRData
# 
# Function: Converts a JSON object to an RData file
# Inputs:   (1) The JSON object
#           (2) Path to the RData file
# Outputs:  (1) Path to the output file
#-------------------------------------------------------
convertJSONtoRData <- function(jsonData, pathToRDataFile) {
  rData = fromJSON(jsonData)
  save(rData, pathToRDataFile)
  return (pathToRDataFile)
}

#-------------------------------------------------------
# uploadRData
# 
# Function: Returns the contents of an RData file as JSON
# Inputs:   (1) Path to the uploaded RData file
# Outputs:  (1) The file data as JSON
#-------------------------------------------------------
uploadRData <- function(fileName) {
  fileData = get(load(fileName))
  return (toJSON(fileData))
}

#-------------------------------------------------------
# createFormula
# 
# Function: Creates a formula string based on the model information
# Inputs:   (1) The model information as JSON
#           (2) Path to the list of variables RData file
# Outputs:  (1) The formula based on the model information
#-------------------------------------------------------
createFormula <- function(model_info_JSON, list_of_variables_RData) {
  
  # model_info = get(load(model_info_RData))
  
  model_info = fromJSON(model_info_JSON)
  list_of_variables = get(load(list_of_variables_RData))
  
  # initialize
  form = "Y ~ "
  inter = " "
  # add linear terms, collect interactions
  for(i in 1:length(model_info)){
    
    # if linear term
    if(model_info[[i]]$linear){
      if(i != 1){
        form = paste(form, " + ", sep = "")
      }
      if(list_of_variables[[i]]$type == "factor"){
        form = paste(form, "as.factor(", model_info[[i]]$name, ")", sep = "")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
            inter = paste(inter, "+ as.factor(", model_info[[i]]$name, ")*", sep = "")
            inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep = "")
          }
        }
      }else{
        form = paste(form, model_info[[i]]$name , sep = "")
        if(!is.null(model_info[[i]]$interaction)){
          for(j in 1:length(model_info[[i]]$interaction)){
            inter = paste(inter, "+ ", model_info[[i]]$name, "*", sep = "")
            inter = paste(inter, form_type(model_info[[i]]$interaction[j], model_info, list_of_variables), sep = "")
          }
        }
      }
    }
  }
  # add interaction terms
  form = paste(form, inter, sep = "")
  
  return (form)
}

form_type <- function(var_name, model_info, list_of_variables){
  
  for(j in 1:length(list_of_variables)){
    if(var_name == list_of_variables[[j]]$name){
      i = j; break
    }
  }
  if(list_of_variables[[i]]$type == "factor"){
    res = paste("as.factor(", model_info[[i]]$name, ")", sep = "")
  }else{
    res = model_info[[i]]$name
  }
  res
}

#-------------------------------------------------------
# createFormulaFile
# 
# Function: Creates a formula RData file based on the model information
# Inputs:   (1) Path to the formula file
#           (2) Model information as JSON
#           (3) Path to the list of variables RData file
#-------------------------------------------------------

createFormulaFile <- function(filePath, modelInfoJSON, listOfVariablesRData) {
  formula = createFormula(modelInfoJSON, listOfVariablesRData)
  save(formula, file = filePath)
}

#-------------------------------------------------------
# processFormulaFile
#
# Function: Generates JSON from a given formula
# Inputs: (1) Path to the RData formula (eg: 'model_predictor.RData')
#         (2) Path to the variables list file (eg: 'list_of_variables.RData')
# Outputs: Returns the formula as JSON
#--------------------------------------------------------

processFormulaFile <- function(formulaFilePath, variablesFilePath) {
  return (toJSON(process_formula_terms(formulaFilePath, variablesFilePath)))
}

process_formula_terms <- function(formulaFilePath, variablesFilePath) {
  
  vars = get(load(variablesFilePath))
  form = get(load(formulaFilePath))
  split = strsplit(gsub(" ", "", substring(form, 4, nchar(form))), "[+]") # split formula string on + signs
  formulaTerms = list()
  interactionTerms = list()
  formulaData = list()
  
  # assign default values
  for (i in 1:length(vars)) {
    formulaData[[i]] = list(name = vars[[i]]$name, linear = FALSE, interaction = NULL)
  }
  
  # get linear/interaction terms
  for (i in 1:length(split[[1]])) {
    term = split[[1]][i]
    
    # if not interaction term
    if (length(grep("[*]", term)) == 0) {
      formulaTerms[length(formulaTerms) + 1] = removeFactor(term)
    }
    
    else {
      interactionTerms[length(interactionTerms) + 1] = term
    }
  }
  
  # check for linear state
  for (i in 1:length(vars)) {
    for (j in 1:length(formulaTerms)) {
      # a formula term is linear if it is found within the list of variables
      if (vars[[i]]$name == formulaTerms[j]) {
        formulaData[[i]]$linear = TRUE
      }
    }
  }
  
  # add interaction terms
  for(i in 1:length(interactionTerms)) {
    term = strsplit(interactionTerms[[i]][1], "[*]")[[1]]
    
    indexTerm = removeFactor(term[1])
    interaction = removeFactor(term[2])
    
    for(j in 1:length(formulaData)) {
      if (indexTerm == formulaData[[j]]$name) {
        #append interaction to list
        formulaData[[j]]$interaction[length(formulaData[[j]]$interaction) + 1] = interaction
      }
    }
  }
  
  return (formulaData)
}

removeFactor <- function(term) {
  if (length(grep("[()]", term)) != 0)
    term = strsplit(term, "[()]")[[1]][2]
  
  return (term)
}

#-------------------------------------------------------
# getLogOddsNames
# 
# Function: Generates the names of log odds ratios
# Inputs:   (1) RData - Path to the list of variables
#           (2) RData - Path to the model predictor
# Outputs:  (1) The list of names as JSON
#-------------------------------------------------------
getLogOddsNames <- function(listOfVariables, modelPredictor) {
  names = verifyModelFormula(listOfVariables, modelPredictor)
  
  return (toJSON(names))
}

#-------------------------------------------------------
# verifyModelFormula
# 
# Function: Verifies the list of variables and model formula
# Inputs:   (1) RData - Path to the list of variables
#           (2) RData - Path to the Model Predictor
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifyModelFormula <- function(listOfVariables, modelPredictor) {
  variables = get(load(listOfVariables))
  predictor = as.formula(get(load(modelPredictor)))
  
  names = get_beta_given_names(variables, predictor)
  
  return (names)
}

#-------------------------------------------------------
# verifyRiskFactorDistribution
# 
# Function: Verifies the risk factor distribution
# Inputs:   (1) CSV - Path to the risk factor distribution file
#           (2) RData - Path to the list of variables
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifyRiskFactorDistribution <- function(riskFactorDistribution, listOfVariables) {
  data = read.csv(riskFactorDistribution, stringsAsFactors = FALSE)
  variables = get(load(listOfVariables))
  
  names = sapply(variables, function(x) x$name)
  
  if (sum(colnames(data) == names) != length(names)) {
    stop("ERROR: Column names must match names and order in list of variables")
  }
}

#-------------------------------------------------------
# verifyLogOddsRatios
# 
# Function: Verifies the log odds ratios
# Inputs:   (1) CSV - Path to log odds ratios file
#           (2) RData - Path to the List of variables
#           (3) RData - Path to the Model Predictor
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifyLogOddsRatios <- function(logOddsRatios, listOfVariables, modelPredictor) {
  rows = verifyModelFormula(listOfVariables, modelPredictor)
  data = read.csv(logOddsRatios)
  
  if (ncol(data) != 2) {
    stop("ERROR: The uploaded log odds ratios file must have two columns")
  }
  
  if (sum(data[[1]] == rows) != length(rows)) {
    stop("ERROR: Row names must match names and order in design matrix.")
  }
}

#-------------------------------------------------------
# verifyDiseaseRates
# 
# Function: Processes the population disease incidence rates file
# Inputs:   (1) The file name
# Outputs:  (1) The information in this file as a data frame
#-------------------------------------------------------
verifyDiseaseRates <- function(diseaseRatesCSV) {
  return (na.omit(check_disease_rates(diseaseRatesCSV)))
}

#-------------------------------------------------------
# verifyCompetingRates
# 
# Function: Processes the competing mortality incidence rates file
# Inputs:   (1) The file name
# Outputs:  (1) The information in this file as a data frame
#-------------------------------------------------------
verifyCompetingRates <- function(competingRatesCSV, diseaseRatesCSV) {
  lambda = verifyDiseaseRates(diseaseRatesCSV)
  return (check_competing_rates(competingRatesCSV, lambda))
}

#-------------------------------------------------------
# verifySNPInfo
# 
# Function: Verifies the SNP info
# Inputs:   (1) CSV - Path to the SNP information
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifySNPInfo <- function(snpInfoCSV) {
  snpInfo = read.csv(snpInfoCSV)
  check_SNP_info(snpInfo)
}

#-------------------------------------------------------
# verifyRiskFactorForPrediction
# 
# Function: Verifies the risk factor for prediction
# Inputs:   (1) CSV - Path to the risk factor for prediction
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifyRiskFactorForPrediction <- function(riskFactorForPredictionCSV) {
  model.cov.info = read.csv(riskFactorForPredictionCSV, stringsAsFactors = FALSE)
  check_triple_check(model.cov.info)
}

#-------------------------------------------------------
# verifyAgeInterval
# 
# Function: Verifies the age/interval file
# Inputs:   (1) CSV - Path to the age/interval file
#           (2) CSV - Path to the risk factor for prediction file
#           (3) CSV - Path to the snp information file
#           (4) CSV - Path to the disease incidence rates file
#           (5) CSV - Path to the competing incidence rates file
# Outputs:  (1) Any error messages from validation
#-------------------------------------------------------
verifyAgeInterval <- function(ageIntervalCSV, 
                              riskFactorForPredictionCSV = NULL, 
                              snpInformationCSV = NULL, 
                              diseaseIncidenceRatesCSV = NULL, 
                              competingIncidenceRatesCSV = NULL) {
  
  ageInterval               = read.csv(ageIntervalCSV)
  ageStart                  = ageInterval[[1]]
  ageIntervalLength         = ageInterval[[2]]
  
  riskFactorForPrediction   = read.csv(riskFactorForPredictionCSV)
  snpInformation            = read.csv(snpInformationCSV)
  diseaseIncidenceRates     = read.csv(diseaseIncidenceRatesCSV)
  competingIncidenceRates   = verifyCompetingRates(competingIncidenceRatesCSV, diseaseIncidenceRates)
  
  check_age_inputs (ageStart, ageIntervalLength, riskFactorForPrediction, 
                    snpInformation, diseaseIncidenceRates, competingIncidenceRates)
}

#-------------------------------------------------------
# finalCalculation
#
# Function: Computes the absolute risk for this model
# Inputs:   (1)  String   - Path prefix for the output files
#           (2)  RData    - Path to the list of variables
#           (3)  RData    - Path to the model formula
#           (4)  CSV      - Path to the risk factor distribution
#           (5)  CSV      - Path to the log odds ratios
#           (6)  CSV      - Path to the disease incidence rates
#           (7)  CSV      - Path to the mortality incidence rates
#           (8)  CSV      - Path to the SNP information
#           (9)  String   - The family history variable name
#           (10) CSV      - Path to the risk factor for prediction
#           (11) CSV      - Path to the genotypes for prediction
#           (12) CSV      - Path to the age/intervals
# 
# Required inputs are: (1)  Path to the output files
#                      (4)  The model disease incidence rates 
#                      (10) The age/intervals file
#
# If the user is working with a model formula the following inputs 
# are required: (2)  The list of variables
#               (3)  The model formula
#               (4)  The risk factor distribution
#               (5)  The log odds ratios
#               (10) The risk factor for prediction
#
# However if the user is working with SNP only then the previous
# five inputs are not used
# 
# Outputs:  An array containing the following:
#           (1) Path to the generated plot
#           (2) Path to the results file
#           (3) Path to the results reference file
# 
#-------------------------------------------------------
finalCalculation <- function(filePath = NULL, listOfVariablesRData = NULL, modelFormulaRData = NULL,
                             riskFactorDistributionCSV = NULL, logOddsRatiosCSV = NULL,
                             diseaseIncidenceRatesCSV, mortalityIncidenceRatesCSV = NULL,
                             snpInformationCSV = NULL, familyHistory = NULL,
                             riskFactorForPredictionCSV = NULL, genotypesForPredictionCSV = NULL,
                             ageIntervalCSV) {
  
  imagePath = paste(filePath, 'rplot.jpg', sep = '_')
  resultsPath = paste(filePath, 'results.csv', sep = '_')
  resultsReferencePath = paste(filePath, 'results_reference.csv', sep = '_')
  
  listOfVariables           = get(load(listOfVariablesRData))
  modelFormula              = as.formula(get(load(modelFormulaRData)))
  
  riskFactorDistribution    = read.csv(riskFactorDistributionCSV, stringsAsFactors = FALSE)
  logOddsRatios             = as.matrix(read.csv(logOddsRatiosCSV, row.names = 1))
  diseaseIncidenceRates     = verifyDiseaseRates(diseaseIncidenceRatesCSV)
  mortalityIncidenceRates   = verifyCompetingRates(mortalityIncidenceRatesCSV, diseaseIncidenceRatesCSV)
  snpInformation            = read.csv(snpInformationCSV)
  
  riskFactorPrediction      = read.csv(riskFactorForPredictionCSV)
  genotypesForPrediction    = read.csv(genotypesForPredictionCSV)
  
  ageInterval               = read.csv(ageIntervalCSV)
  ageStart                  = ageInterval[[1]]
  ageIntervalLength         = ageInterval[[2]]
  
  results = compute.absolute.risk(model.formula = modelFormula, 
                                  model.cov.info = listOfVariables, 
                                  model.ref.dataset = riskFactorDistribution,
                                  model.ref.dataset.weights = NULL,
                                  model.log.RR = logOddsRatios,
                                  model.disease.incidence.rates = diseaseIncidenceRates,
                                  model.competing.incidence.rates = mortalityIncidenceRates,
                                  model.snp.info = snpInformation,
                                  model.bin.fh.name = familyHistory, n.imp = 5,
                                  apply.cov.profile = riskFactorPrediction,
                                  apply.snp.profile = genotypesForPrediction,
                                  apply.age.start = ageStart,
                                  apply.age.interval.length = ageIntervalLength,
                                  use.c.code = 1, return.lp = FALSE, return.refs.risk = TRUE)
  
  if (length(results$risk) <= 12) {
    jpeg(imagePath, width = 9, height = 9, units = 'in', res = 600)
    par(mfrow = c(3, 4))
    
    for (i in 1:length(results$risk)) {
      plot(density(results$refs.risk, na.rm = T),
           main = paste("Subject", i),
           ylab = "Smoothed Frequency Density",
           xlab = "Absolute Risk", lwd = 2)
      
      lines(abline(v = results$risk[i], col = "red", lwd = 2))
    }
    dev.off()
    
  } else {
    jpeg(imagePath, width = 9, height = 9, units = 'in', res = 600)
    plot(density(results$risk, na.rm = T), 
         main = "Absolute Risk Distribution", 
         ylab = "Smoothed Frequency Density", 
         xlab = "Absolute Risk", lwd = 2)
    dev.off()
  }
  
  res = results$details
  ref = results$refs.risk
  
  write.csv(res, file = resultsPath)
  write.csv(ref, file = resultsReferencePath)
  
  results = c(imagePath, resultsPath, resultsReferencePath)
  return (results)
}


#-------------------------------------------------------
# saveSession
#
# Function: Creates a session file from the given RData
# Inputs:   (1)  String   - Path to the sesion file
#           (2)  RData    - Path to the list of variables
#           (3)  RData    - Path to the model formula
#           (4)  CSV      - Path to the risk factor distribution
#           (5)  CSV      - Path to the log odds ratios
#           (6)  CSV      - Path to the disease incidence rates
#           (7)  CSV      - Path to the mortality incidence rates
#           (8)  CSV      - Path to the SNP information
#           (9)  String   - The family history variable name
# 
#-------------------------------------------------------

saveSession <- function(filePath = NULL, listOfVariablesRData = NULL, modelFormulaRData = NULL,
                        riskFactorDistributionCSV = NULL, logOddsRatiosCSV = NULL,
                        diseaseIncidenceRatesCSV, mortalityIncidenceRatesCSV = NULL,
                        snpInformationCSV = NULL, familyHistory = NULL) {
  
  model = list()
  
  model$listOfVariables           = get(load(listOfVariablesRData))
  model$modelFormula              = get(load(modelFormulaRData))
  
  model$riskFactorDistribution    = read.csv(riskFactorDistributionCSV, stringsAsFactors = FALSE)
  model$logOddsRatios             = as.matrix(read.csv(logOddsRatiosCSV, row.names = 1))
  model$diseaseIncidenceRates     = verifyDiseaseRates(diseaseIncidenceRatesCSV)
  model$mortalityIncidenceRates   = verifyCompetingRates(mortalityIncidenceRatesCSV, diseaseIncidenceRates)
  model$snpInformation            = read.csv(snpInformationCSV)
  model$familyHistory             = familyHistory  
  
  save(model, file = filePath)
}

#-------------------------------------------------------
# loadSession
#
# Function: Creates RData and CSV files from a saved session file
# Inputs:   (1)  The path to the output files
#           (2)  The path to the saved session file
# Outputs:  A vector consisting of: 
#           (1)  RData    - Path to the list of variables
#           (2)  RData    - Path to the model formula
#           (3)  CSV      - Path to the risk factor distribution
#           (4)  CSV      - Path to the log odds ratios
#           (5)  CSV      - Path to the disease incidence rates
#           (6)  CSV      - Path to the mortality incidence rates
#           (7)  CSV      - Path to the SNP information
#           (8)  String   - The family history variable name
# 
#-------------------------------------------------------

loadSession <- function(filePath, sessionFile) {
  
  model = get(load(sessionFile))
  
  listOfVariables             = model$listOfVariables
  modelFormula                = model$modelFormula
  
  riskFactorDistribution      = model$riskFactorDistribution
  logOddsRatios               = model$logOddsRatios
  diseaseIncidenceRates       = model$diseaseIncidenceRates
  mortalityIncidenceRates     = model$mortalityIncidenceRates
  snpInformation              = model$snpInformation
  familyHistory               = model$familyHistory
  
  listOfVariablesPath         = paste(filePath, "list_of_variables.rdata", sep = "_")
  modelFormulaPath            = paste(filePath, "model_predictor.rdata", sep = "_")
  riskFactorDistributionPath  = paste(filePath, "risk_factor_distribution.csv", sep = "_")
  logOddsRatiosPath           = paste(filePath, "log_odds_ratios.csv", sep = "_")
  diseaseIncidenceRatesPath   = paste(filePath, "disease_incidence_rates.csv", sep = "_")
  mortalityIncidenceRatesPath = paste(filePath, "mortality_incidence_rates.csv", sep = "_")
  snpInformationPath          = paste(filePath, "snp_information.csv", sep = "_")
  
  save(listOfVariables, file = listOfVariablesPath)
  save(modelFormula, file = modelFormulaPath)
  
  write.csv(riskFactorDistribution, file = riskFactorDistributionPath)
  write.csv(logOddsRatios, file = logOddsRatiosPath)
  write.csv(diseaseIncidenceRates, file = diseaseIncidenceRatesPath)
  write.csv(mortalityIncidenceRates, file = mortalityIncidenceRatesPath)
  write.csv(snpInformation, file = snpInformationPath)
  
  return (c(listOfVariablesPath,
            modelFormulaPath,
            logOddsRatiosPath,
            diseaseIncidenceRatesPath,
            mortalityIncidenceRatesPath,
            snpInformationPath,
            familyHistory))
}
