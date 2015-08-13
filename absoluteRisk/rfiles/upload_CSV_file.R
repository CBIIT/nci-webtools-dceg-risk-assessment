#-------------------------------------------------------
# Name: upload_CSV_file.R
# Note: R function to handle the upload of a CSV file
# Inputs: the input file name has the extension of csv 
# Outputs: return the corresponding RData filename with the extension ".RData"
#--------------------------------------------------------
#
# Test Code:
#
# > uploadCSV("cov_new.csv")
#     [1] "cov_new.RData"
# > test=uploadCSV("cov_new.csv")
# > test
#     [1] "cov_new.RData"
# > load(test)
# > mydata=load(test)
# > mydata
#     [1] "cov_new"
# > get(mydata)
#
#    famhist menarche_dec parity birth_dec agemeno_dec height_dec bmi_dec rd_menohrt rd2_everhrt_e rd2_everhrt_c rd2_currhrt
# 1         1            1      3         1           1         10       9          2             1             0           0
#--------------------------------------------------------

library(tools)

uploadCSV <- function(filename)
{
                # mydata = read.table(filename, header = TRUE, sep = ",",  as.is = TRUE)

		mydata <- read.csv(filename, sep=",",header=TRUE,stringsAsFactor=FALSE)

                baseFileName = file_path_sans_ext(filename)
		varName = basename(baseFileName)
		assign(varName,mydata)
                rdataFileName = paste(baseFileName,".RData",sep="") 
                save(list=varName, file=rdataFileName)
                
                return (rdataFileName)
}


getRDataInfo <- function(filename) {
  
  mydata = read.table(filename, header = TRUE, sep = ",",  as.is = TRUE)
  
  return (mydata)

}
