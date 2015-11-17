library(rjson)
library(iCare)

#-------------------------------------------------------
# convertJSONtoRData
# 
# Function: Converts a JSON object to an RData file
# Inputs:   (1) The JSON object
#           (2) The path to the RData file
#-------------------------------------------------------
convertJSONtoRData <- function(jsonData, pathToRDataFile) {
  rData = fromJSON(jsonData)
  save(rData, pathToRDataFile)
}

#-------------------------------------------------------
# uploadRData
# 
# Function: Returns the contents of an RData file as JSON
# Inputs:   (1) The path to the uploaded RData file
# Outputs:  The file data as JSON
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
#           (2) The path to the list of variables RData file
# Outputs:  The formula based on the model information
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
# Inputs:   (1) The path to the formula file
#           (2) The model information as JSON
#           (3) The path to the list of variables RData file
#-------------------------------------------------------

createFormulaFile <- function(filePath, modelInfoJSON, listOfVariablesRData) {
    formula = createFormula(modelInfoJSON, listOfVariablesRData)
    
    save(formula, file = filePath)
}

#-------------------------------------------------------
# processFormulaFile
#
# Function: Generates JSON from a given formula
# Inputs: (1) The path to the RData formula (eg: 'model_predictor.RData')
#         (2) The path to the variables list file (eg: 'list_of_variables.RData')
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
# processRiskFactorDistribution
# 
# Function: Processes the risk factor distribution file
# Inputs:   (1) The file name
# Outputs:  The information in this file as a data frame
#-------------------------------------------------------
processRiskFactorDistribution <- function(fileName) {
  fileData = read.csv(fileName)
  i <- sapply(fileData, is.factor)
  fileData[i] <- lapply(fileData[i], as.character)
  
  return (fileData)
}

#-------------------------------------------------------
# processLogOdds
# 
# Function: Processes the log odds rates file
# Inputs:   (1) The file name
# Outputs:  The information in this file as a matrix
#-------------------------------------------------------
processLogOdds <- function(fileName) {
  fileData = read.csv(fileName)
  logOddsData = matrix(fileData[[2]], ncol = 1)
  rownames(logOddsData) = fileData[[1]]
  
  return (logOddsData)
}

#-------------------------------------------------------
# processDiseaseRates
# 
# Function: Processes the population disease incidence rates file
# Inputs:   (1) The file name
# Outputs:  The information in this file as a data frame
#-------------------------------------------------------
processDiseaseRates <- function(fileName) {
  return (na.omit(check_disease_rates(fileName)))
}

#-------------------------------------------------------
# processCompetingRates
# 
# Function: Processes the competing mortality incidence rates file
# Inputs:   (1) The file name
# Outputs:  The information in this file as a data frame
#-------------------------------------------------------
processCompetingRates <- function(competingRatesCSV, lambda) {
  return (check_competing_rates(competingRatesCSV, lambda))
}

#-------------------------------------------------------
# finalCalculation
#
# Function: Computes the absolute risk for this model
# Inputs:   (1)  String   - The path prefix for the output files
#           (2)  RData    - The path to the list of variables
#           (3)  RData    - The path to the model formula
#           (4)  CSV      - The path to the risk factor distribution
#           (5)  CSV      - The path to the log odds ratios
#           (6)  CSV      - The path to the disease incidence rates
#           (7)  CSV      - The path to the mortality incidence rates
#           (8)  CSV      - The path to the SNP information
#           (9)  String   - The family history variable name
#           (10) CSV      - The path to the risk factor for prediction
#           (11) CSV      - The path to the genotypes for prediction
#           (12) CSV      - The path to the age/intervals
# 
# Required inputs are: (1)  The path to the output files
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
# five inputs are not required
# 
# Outputs:  An array containing the following:
#           (1) The path to the generated plot
#           (2) The path to the results file
#           (3) The path to the results reference file
# 
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
  
  modelFormula              = as.formula(get(load(modelFormulaRData)))
  listOfVariables           = get(load(listOfVariablesRData))
  
  riskFactorDistribution    = processRiskFactorDistribution(riskFactorDistributionCSV)
  logOddsRatios             = processLogOdds(logOddsRatiosCSV)
  diseaseIncidenceRates     = processDiseaseRates(diseaseIncidenceRatesCSV)
  mortalityIncidenceRates   = processCompetingRates(mortalityIncidenceRatesCSV, diseaseIncidenceRates)
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