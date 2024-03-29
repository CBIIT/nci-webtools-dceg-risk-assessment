library('RJSONIO')
library('stringr')

#source ('./BiomarkerComparison.R')

rm(list=ls(all=TRUE))
library(coxph.risk)
source("cuts.R")
source("kovalchik_cbiit.R")
load("cbiit_models.RData")

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


runLungCancerScreening <- function(age,bmi,cpd,emp,fam.lung.trend,female,qtyears,smkyears,race,edu6,pkyr.cat)
{

  race <- factor(race)

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

result5 <- 100*(1.0 - nhis$prob_0falsepos)
result5

xx = 10 * result1
yy = 10 * result2
cc = 0
zz = 10 * result3
aa = 10 * (result4 - result3)
bb = 10 * result5

# calculation of top x% from the risk distribution table for “cc”
dist=read.csv("risk_distributions.csv")
size <- dim(dist)
nrow <- size[1]

for(i in 1:nrow)
{ if (result1 > dist[i,2])
  {cc=1000*(1 - dist[i,1]);
   break;}
}

#Outputs in UI:
#1.       Risk of dying from lung cancer within 5 years in the absence of screening is result1 (in %)
#2.       Risk reduction due to lung cancer screening is result2 (in %)
#3.       The chance of lung cancer diagnosis within 5 years in the absence of screening is result3 (in %)
#4.       The chance of lung cancer diagnosis within 5 years with screening is result4 (in %)
#5.       The chance of having a false positive result after 3 screens is result5 (in %)


return (c(xx,yy,zz,aa,bb,cc))

}
