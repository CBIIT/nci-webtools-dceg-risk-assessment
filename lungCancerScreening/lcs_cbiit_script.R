#This program predicts risks using LCDRAT, LCRAT, cxLCDRAT, and cxLCRAT models.  
#This program also calculates the probability of false positives and the expected number of false positives.
rm(list=ls(all=TRUE))
library(coxph.risk)

#code used for cut-points
source("P:/bb/lrisk/prog/cuts.R")

#code used to predict lung cancer death and lung cancer incidence
source("P:/bb/lrisk/prog/kovalchik_cbiit.R")

#contains LCDRAT: lung cancer risk model, LCRAT: lung cancer incidence model, cox.death: competing model for death, polytmod: model for number of false positives
load("P:/bb/lrisk/other/cbiit_models.RData")

#load data to conduct predictions on
load("P:/bb/lrisk/other/nhis/nhis_cbiit.RData")

#calculate predicted risks of lung cancer death within 5 years based on LCDRAT with competing risk of death
nhis$LCDRAT <- risk.kovalchik(0, 5, nhis, LCDRAT, cox.death)
summary(nhis$LCDRAT)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#5.600e-07 1.283e-04 8.648e-04 6.805e-03 5.398e-03 2.043e-01 

#calculate predicted risks based on chest xray
nhis$cxLCDRAT <- 0.796*nhis$LCDRAT
summary(nhis$cxLCDRAT)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#4.500e-07 1.021e-04 6.884e-04 5.417e-03 4.297e-03 1.626e-01 

#calculate predicted risks of lung cancer incidence within 5 years based on LCRAT with competing risk of death
nhis$LCRAT <- risk.kovalchik(0, 5, nhis, LCRAT, cox.death)
summary(nhis$LCRAT)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#1.073e-05 4.883e-04 2.105e-03 1.034e-02 9.137e-03 2.960e-01 

nhis$cxLCRAT <- 1.124*nhis$LCRAT
summary(nhis$cxLCRAT)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
#0.0000121 0.0005489 0.0023660 0.0116200 0.0102700 0.3327000 

#calculate probability of Y, number of false positives, taking values of 0, 1, 2, or 3 
#responses are reported as log(P(Y=1)/P(Y=0)), log(P(Y=2)/P(Y=0)), and log(P(Y=3)/P(Y=0))
prob_numfalsepos <- predict(polytmod,type="response",newdata=nhis)

#solving for P(Y=0), P(Y=1), P(Y=2), and P(Y=3), we have:
nhis$prob_0falsepos <- 1/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_1falsepos <- exp(prob_numfalsepos[,1])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_2falsepos <- exp(prob_numfalsepos[,2])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))
nhis$prob_3falsepos <- exp(prob_numfalsepos[,3])/(1+exp(prob_numfalsepos[,1])+exp(prob_numfalsepos[,2])+exp(prob_numfalsepos[,3]))

summary(nhis$prob_0falsepos)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.4914  0.6783  0.7443  0.7365  0.7998  0.8999 
summary(nhis$prob_1falsepos)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.04105 0.08338 0.10650 0.10920 0.13330 0.20510 
summary(nhis$prob_2falsepos)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.04870 0.08718 0.10610 0.10690 0.12650 0.17350 
summary(nhis$prob_3falsepos)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.01036 0.02968 0.04323 0.04739 0.06181 0.13010 

#calculate expected number of false positives
nhis$expected_falsepos <- nhis$prob_1falsepos + 2*nhis$prob_2falsepos + 3*nhis$prob_3falsepos
summary(nhis$expected_falsepos)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.1695  0.3468  0.4483  0.4652  0.5718  0.9422 
 
save(nhis,file="P:/bb/lrisk/other/nhis_results.RData")
