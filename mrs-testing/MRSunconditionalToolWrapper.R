library('RJSONIO')
source('./MRSunconditionalTool.R')

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
	data = convertToJSON(data)

  	return (data)
	
}

getJSON_PPVNPVprobM <- function(PPV,NPV,probM,total) {

    	abcd <- PPVNPVprobM_abcd(PPV,NPV,probM,total)
	data = getJSON_abcd(abcd)

	return (data)
}

getJSON_PPVNPVprobD <- function(PPV,NPV,probD,total) {

	abcd <- PPVNPVprobD_abcd(PPV,NPV,probD,total)
	data = getJSON_abcd(abcd)
	
	return (data)
	
}

getJSON_sensspecprobM <- function(sens,spec,probM,total) {

	abcd <- sensspecprobM_abcd(sens,spec,probM,total)
	data = getJSON_abcd(abcd)

	return (data)

}

getJSON_sensspecprobD <- function(sens,spec,probD,total) {

	abcd <- sensspecprobD_abcd(sens,spec,probD,total)
	data = getJSON_abcd(abcd)

	return (data)

}
		          



