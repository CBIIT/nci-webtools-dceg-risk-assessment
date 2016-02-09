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
  save(rData, file = pathToRDataFile)
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
# verifyFile
# 
# Function: Validates an input file
# Inputs:   (1) A JSON object with the following fields: 
#              (1)  id         - The id of the file being validated
#              (2)  filePaths  - A list containing the paths to the input files
#                 (1)  listOfVariables
#                 (2)  modelFormula
#                 (3)  riskFactorDistribution
#                 (4)  logOddsRatios
#                 (5)  diseaseIncidenceRates
#                 (6)  mortalityIncidenceRates
#                 (7)  snpInformation
#                 (8)  riskFactorPrediction
#                 (9)  genotypesForPrediction
#                 (10) ageInterval
#
# Outputs:  (1) File validation error messages
#-------------------------------------------------------
verifyFile <- function(param) {
  
  param = fromJSON(param)
  filePaths = param$filePaths
  errors = list()
  data = list()

  for (key in names(filePaths)) {
    if (filePaths[[key]] != "") {
      data[[key]] = switch(key,
        listOfVariables          = get(load(filePaths$listOfVariables)),
        modelFormula             = as.formula(get(load(filePaths$modelFormula))),
        riskFactorDistribution   = read.csv(filePaths$riskFactorDistribution, stringsAsFactors = F),
        logOddsRatios            = read.csv(filePaths$logOddsRatios, stringsAsFactors = F),
        diseaseIncidenceRates    = read.csv(filePaths$diseaseIncidenceRates),
        mortalityIncidenceRates  = read.csv(filePaths$mortalityIncidenceRates),
        snpInformation           = read.csv(filePaths$snpInformation, stringsAsFactors = F),
        riskFactorForPrediction  = read.csv(filePaths$riskFactorForPrediction, stringsAsFactors = F),
        genotypesForPrediction   = read.csv(filePaths$genotypesForPrediction),
        ageInterval              = read.csv(filePaths$ageInterval)
      )
    }
  }
  
  tryCatch(
    switch(param$id,
           
      listOfVariables = {
        check_triple_check(data$listOfVariables)
      },
      
      modelFormula = {
        get_beta_given_names(data$listOfVariables, data$modelFormula)
      }, 
      
      riskFactorDistribution = {
        names = sapply(data$listOfVariables, function(x) x$name)
        if (sum(colnames(data$riskFactorDistribution) == names) != length(names))
          stop("ERROR: Column names must match names and order in list of variables")      
      },
      
      logOddsRatios = {
        rows = get_beta_given_names(data$listOfVariables, data$modelFormula)
  
        if (ncol(data$logOddsRatios) != 2)
          stop("ERROR: The uploaded log odds ratios file must have two columns")
        
        if (sum(data$logOddsRatios[[1]] == rows) != length(rows))
          stop("ERROR: Row names must match names and order in design matrix.")
      },
      
      diseaseIncidenceRates = {
        check_disease_rates(filePaths$diseaseIncidenceRates)
      },
      
      mortalityIncidenceRates = {
        lambda = na.omit(check_disease_rates(filePaths$diseaseIncidenceRates))
        check_competing_rates(filePaths$mortalityIncidenceRates, lambda)
      },
      
      snpInformation = {
        check_SNP_info(data$snpInformation)
      },
      
      riskFactorForPrediction = {
#        check_triple_check(data$riskFactorPrediction)
      },
      
      genotypesForPrediction = {
        # Verify column names are equal to snp row names
      },
      
      ageInterval = {
        ageStart                  = data$ageInterval[[1]]
        interval                  = data$ageInterval[[2]]
        riskFactorForPrediction   = data$riskFactorForPrediction
        snpInformation            = data$snpInformation
        diseaseIncidenceRates     = na.omit(check_disease_rates(filePaths$diseaseIncidenceRates))
        competingIncidenceRates   = check_competing_rates(filePaths$competingIncidenceRates, diseaseIncidenceRates)

        if (filePaths$riskFactorForPrediction != "")
          snpInformation = NULL
        
        validations = check_age_inputs (ageStart, interval, riskFactorForPrediction, 
                          snpInformation, diseaseIncidenceRates, competingIncidenceRates)
        
        
        
        print(param$id)
        print(validations)
      }
    ), error = function(e) { print (e);  errors <<- e$message }
  )

  return (toJSON(errors))
}

#-------------------------------------------------------
# finalCalculation
#
# Function: Computes the absolute risk for this model
# Inputs:   (1)  String   - Path prefix for the output files
#           (2)  String   - JSON string containing filepaths/parameters
#              (1)  RData    - Path to the list of variables
#              (2)  RData    - Path to the model formula
#              (3)  CSV      - Path to the risk factor distribution
#              (4)  CSV      - Path to the log odds ratios
#              (5)  CSV      - Path to the disease incidence rates
#              (6)  CSV      - Path to the mortality incidence rates
#              (7)  CSV      - Path to the SNP information
#              (8)  String   - The family history variable name
#              (9)  CSV      - Path to the risk factor for prediction
#              (10) CSV      - Path to the genotypes for prediction
#              (11) CSV      - Path to the age/intervals
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
finalCalculation <- function(filePath, parameters) {

  imagePath             = paste0(filePath, 'rplot.jpg')
  resultsPath           = paste0(filePath, 'results.csv')
  resultsReferencePath  = paste0(filePath, 'results_reference.csv')
  
  param = fromJSON(parameters)
  
  listOfVariables           = get(load(param$listOfVariables))
  modelFormula              = as.formula(get(load(param$modelFormula)))
  
  riskFactorDistribution    = read.csv(param$riskFactorDistribution, stringsAsFactors = FALSE)
  logOddsRatios             = as.matrix(read.csv(param$logOddsRatios, row.names = 1))
  diseaseIncidenceRates     = na.omit(check_disease_rates(param$diseaseIncidenceRates))
  mortalityIncidenceRates   = check_competing_rates(param$mortalityIncidenceRates, diseaseIncidenceRates)
  snpInformation            = read.csv(param$snpInformation)
  familyHistory             = param$familyHistory
  
  riskFactorPrediction      = read.csv(param$riskFactorForPrediction)
  genotypesForPrediction    = read.csv(param$genotypesForPrediction)
  
  ageInterval               = read.csv(param$ageInterval)
  ageStart                  = ageInterval[[1]]
  interval                  = ageInterval[[2]]

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
                                  apply.age.interval.length = interval,
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

  results = list(imagePath = imagePath, resultsPath = resultsPath, resultsReferencePath = resultsReferencePath)
  return (toJSON(results))
}


#-------------------------------------------------------
# saveSession
#
# Function: Creates a session file from the given RData
# Inputs:   (1)  String        - Path to output file
#           (2)  Session       - JSON string containing 
#              (1)  RData    - Path to the list of variables
#              (2)  RData    - Path to the model formula
#              (3)  CSV      - Path to the risk factor distribution
#              (4)  CSV      - Path to the log odds ratios
#              (5)  CSV      - Path to the disease incidence rates
#              (6)  CSV      - Path to the mortality incidence rates
#              (7)  CSV      - Path to the SNP information
#              (8)  String   - The family history variable name
# 
#-------------------------------------------------------

saveSession <- function(filePath, sessionData) {

  print(sessionData)
  sessionData = fromJSON(sessionData)
  print(sessionData)
  session = list()

  session $listOfVariables           = get(load(sessionData $listOfVariables))
  session $modelFormula              = as.formula(get(load(sessionData $modelFormula)))
  
  session $riskFactorDistribution    = read.csv(sessionData $riskFactorDistribution, stringsAsFactors = FALSE)
  session $logOddsRatios   = as.matrix(read.csv(sessionData $logOddsRatios, row.names = 1))
  session $diseaseIncidenceRates     = read.csv(sessionData $diseaseIncidenceRates)
  session $mortalityIncidenceRates   = read.csv(sessionData $mortalityIncidenceRates)
  session $snpInformation            = read.csv(sessionData $snpInformation)
  session $familyHistory             = sessionData $familyHistory
  
  save(session, file = filePath)
}

#-------------------------------------------------------
# loadSession
#
# Function: Creates RData and CSV files from a saved session file
# Inputs:   (1)  The path to the output files
#           (2)  The path to the saved session file
# Outputs:  A JSON object consisting of: 
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
  
  restore = list()
  model = get(load(sessionFile))
  
  listOfVariables             = model $listOfVariables
  modelFormula                = model $modelFormula
  
  riskFactorDistribution      = model $riskFactorDistribution
  logOddsRatios               = model $logOddsRatios
  diseaseIncidenceRates       = model $diseaseIncidenceRates
  mortalityIncidenceRates     = model $mortalityIncidenceRates
  snpInformation              = model $snpInformation
  familyHistory               = model $familyHistory
  
  restore $filePaths $listOfVariables               = paste0(filePath, "listOfVariables.rdata")
  restore $filePaths $modelFormula                  = paste0(filePath, "modelFormula.rdata")
  restore $filePaths $riskFactorDistribution        = paste0(filePath, "riskFactorDistribution.csv")
  restore $filePaths $logOddsRatios                 = paste0(filePath, "logOddsRatios.csv")
  restore $filePaths $diseaseIncidenceRates         = paste0(filePath, "diseaseIncidenceRates.csv")
  restore $filePaths $mortalityIncidenceRates       = paste0(filePath, "mortalityIncidenceRates.csv")
  restore $filePaths $snpInformation                = paste0(filePath, "snpInformation.csv")

  save(listOfVariables,  file = restore $filePaths $listOfVariables)
  save(modelFormula,     file = restore $filePaths $modelFormula)
  
  write.csv(riskFactorDistribution,   row.names=FALSE, file = restore $filePaths $riskFactorDistribution)
  write.csv(logOddsRatios,            row.names=TRUE,  file = restore $filePaths $logOddsRatios)
  write.csv(diseaseIncidenceRates,    row.names=FALSE, file = restore $filePaths $diseaseIncidenceRates)
  write.csv(mortalityIncidenceRates,  row.names=FALSE, file = restore $filePaths $mortalityIncidenceRates)
  write.csv(snpInformation,           row.names=FALSE, file = restore $filePaths $snpInformation)
  
  formula = as.character(modelFormula)
  restore $model $listOfVariables        = listOfVariables
  restore $model $formulaString          = paste(formula[2], formula[1], formula[3])
  restore $model $snpRowNames            = snpInformation[[1]]
  restore $model $familyHistory          = model$familyHistory

  return (toJSON(restore))
}
