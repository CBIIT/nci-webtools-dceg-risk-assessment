
#-----------------------------------------------------
# Name: upload_RData_file.R
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

library(tools)
library(rjson)

uploadRData <- function(filename)
{

	# get() returns the variable name from load(filename)

	tmp = load(filename)
	tmpvar = get(tmp)
	result = toJSON(tmpvar)
	return (result)


}


