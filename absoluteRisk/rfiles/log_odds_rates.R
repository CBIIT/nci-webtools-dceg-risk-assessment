
#------------------------------------------
# Name: log_odds_rates.R
# Function: File to generate the names of log odds rates (aka "beta_given")
# Inputs: (1) RData file name for list_of_variables (e.g.list_of_variables.RData") and
#         (2) RData file name for model_predictor (e.g.,"model_predictor.RData")
# Outputs: return the listnames in JSON format
#------------------------------------------
#
# Test Code:
#
# > t1=c("list_of_variables.RData")
# > t2=c("model_predictor.RData")
# > qq=log_odds_rates(t1,t2)
# > qq
#     [1] "[\"famhist\",\"as.factor(menarche_dec)2\",\"as.factor(menarche_dec)3\",
#           \"as.factor(menarche_dec)5\"
# > aa=fromJSON(qq)
# > aa
#    [1] "famhist"                                     "as.factor(menarche_dec)2"                   
#    [3] "as.factor(menarche_dec)3"                    "as.factor(menarche_dec)5"                   
#
#-------------------------------------------
#

library(rjson)
source("absolute_risk_code_V4.15.R")

log_odds_rates <- function(list_of_variables_RData, model_predictor_RData)
{
   list_of_variables=get(load(list_of_variables_RData))
   model_predictor=get(load(model_predictor_RData))

   listnames = get_beta_given_names(list_of_variables, as.formula(model_predictor))
   listnamesJSON= toJSON(listnames)
   return (listnamesJSON)
}


