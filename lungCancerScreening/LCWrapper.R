library('RJSONIO')
source('./LC.R')

imageDirectory = "./tmp"


#convertToJSON <- function (data) {
# convert to named lists 
#  parameters=apply(data$parameters, 1, as.list)
#  calculations=apply(data$calculations, 1, as.list)
#  namedData=list(parameters=parameters, calculations=calculations)
#  return(toJSON(namedData, .withNames=TRUE, .escapeEscapes=TRUE))
#}

getJSONData <- function(age,bmi,cpd,emp,fam.lung.trend,gender,qtyears,smkyears,race,edu6,pkyr.cat) {

	data <- runLungCancerScreening(age,bmi,cpd,emp,fam.lung.trend,gender,qtyears,smkyears,race,edu6,pkyr.cat)
	data <- toJSON(data)

  	return (data)
	
}


