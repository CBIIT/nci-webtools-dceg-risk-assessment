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

runLungCancerScreening <- function(abcd) {

	data <- (abcd)
	data <- toJSON(data)

  	return (data)
	
}


