library('RJSONIO')
source('./MRSunconditionalTool.R')

options(scipen=-100)

imageDirectory = "./tmp"


convertToJSON <- function (data) {
  # convert to named lists 
  parameters=apply(data$parameters, 1, as.list)
  calculations=apply(data$calculations, 1, as.list)
  namedData=list(parameters=parameters, calculations=calculations)
  return(toJSON(namedData, .withNames=TRUE, .escapeEscapes=TRUE))
}

getJSON_abcd <- function(abcd) {

	data <- MRSunconditional(abcd)
	
	jsonString =convertToJSON(data)
  return(jsonString)
	
}

getJSON_PPVNPVprobM <- function(PPV,NPV,probM,total) {

    	data <- PPVNPVprobM_abcd(PPV,NPV,probM,total)

	jsonString = ""
	jsonString = toJSON(data)
}

getJSON_PPVNPVprobD <- function(PPV,NPV,probD,total) {

	data <- PPVNPVprobD_abcd(PPV,NPV,probD,total)
        
	jsonString = ""
	jsonString = toJSON(data)
}

getJSON_sensspecprobM <- function(sens,spec,probM,total) {

	data <- sensspecprobM(sens,spec,probM,total)

	jsonString = ""
        jsonString = toJSON(data)

}

getJSON_sensspecprobD <- function(sens,spec,probD,total) {

	data <- sensspecprobD(sens,spec,probD,total)

       	jsonString = ""
       	jsonString = toJSON(data)

}
		          



