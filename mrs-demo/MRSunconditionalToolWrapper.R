library('RJSONIO')
source('./MRSunconditionalTool.R')

options(scipen=-100)

imageDirectory = "./tmp"

getJSON_abcd <- function(abcd) {

	data <- MRSunconditional(abcd)
	
	jsonString = ""
	jsonString = toJSON(data)

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
		          



