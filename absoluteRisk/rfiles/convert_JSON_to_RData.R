
#-----------------------------------------
# Name: convertJSONtoRData.R
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


library(rjson)

convertJSONtoRData <- function(myJSONdata, filename) {
 	rData <- fromJSON(myJSONdata)
	save(rData, file=filename)
}
