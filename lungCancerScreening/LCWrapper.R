library('RJSONIO')
library('stringr')

#source ('./BiomarkerComparison.R')

library(VGAM)
rm(list=ls(all=TRUE))
library(coxph.risk)
source("h:/Rwork/Lung/cuts.R")
source("h:/Rwork/Lung/kovalchik_cbiit.R")
load("h:/Rwork/Lung/cbiit_models.RData")

#imageDirectory="./tmp/" 
 
#######
#
#  example urlEncodedString
#  
#  age=61&bmi=27.25&cpd=8.911385&…..
#
######

# nhis <- data.frame(age=61,
#                  bmi=27.25,
#                  cpd=8.911385,
#                  emp=0,
#                  fam.lung.trend=0,
#           	    female=1,
#       	    qtyears=20.0,
#        	    smkyears=35.0,
#        	    race=2,
#        	    edu6=1,
#        	    pkyr.cat=15.59492375)


getDataJSON <- function(urlEncodedString)
{
  inputList=parseURLEncodedString(urlEncodedString)
  
  age <- inputList[[1]][[1]]
  bmi <- inputList[[2]][[1]]
  cpd <- inputList[[3]][[1]]
  fam.lung.trend <- inputList[[4]][[1]])
  female <- inputList[[5]][[1]]
  qtyears <- inputList[[6]][[1]]
  smkyears <- inputList[[7]][[1]]
  race <- factor(inputList[[8]][[1]])
  edu6 <- inputList[[9]][[1]]
  pkyr.cat <- inputList[[10]][[1]]

nhis <- data.frame(age, bmi, cpd, emp, fam.lung.trend, female,
        qtyears, smkyears, race, edu6, pkyr.cat)


nhis$LCDRAT <- risk.kovalchik(0, 5, nhis, LCDRAT, cox.death)
nhis$LCDRAT

nhis$cxLCDRAT <- 0.796*nhis$LCDRAT
nhis$cxLCDRAT

nhis$LCRAT <- risk.kovalchik(0, 5, nhis, LCRAT, cox.death)
nhis$LCRAT

nhis$cxLCRAT <- 1.124*nhis$LCRAT
nhis$cxLCRAT

prob_numfalsepos <- predict(polytmod,type="response",newdata=nhis)
nhis$prob_0falsepos <- 1/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_0falsepos
nhis$prob_1falsepos <- exp(prob_numfalsepos[,1])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_1falsepos
nhis$prob_2falsepos <- exp(prob_numfalsepos[,2])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_2falsepos
nhis$prob_3falsepos <- exp(prob_numfalsepos[,3])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_3falsepos

nhis$expected_falsepos <- nhis$prob_1falsepos + 2*nhis$prob_2falsepos + 3*nhis$prob_3falsepos
nhis$expected_falsepos
 
result1 <- 100*nhis$LCDRAT  
result1

result2 <- 100*(nhis$LCDRAT - nhis$cxLCDRAT)
result2

result3 <- 100*nhis$LCRAT
result3

result4 <- 100*nhis$cxLCRAT
result4

result5 <- 1.0 - nhis$prob_0falsepos
result5

 
#Outputs in UI:
#1.       Risk of dying from lung cancer within 5 years in the absence of screening is result1 (in %)
#2.       Risk reduction due to lung cancer screening is result2 (in %)
#3.       The chance of lung cancer diagnosis within 5 years in the absence of screening is result3 (in %)  
#4.       The chance of lung cancer diagnosis within 5 years with screening is result4 (in %) 
#5.       The chance of having a false positive result after 3 screens is result5 (in %)


  jsonString <- ""
  jsonString <- toJSON(c(result1, result2, result3,result4, result5)
}

#----------------------------------------------
parseURLEncodedString <- function (urlEncodedString) {
  string <- URLdecode(urlEncodedString);
  inputList <- lapply(strsplit(string, "&")[[1]], function(x){
    tmp <- strsplit(x, "=")
    val <- tmp[[1]][[2]]
    names(val) <- tmp[[1]][[1]]
    as.list(val)
  });
}

