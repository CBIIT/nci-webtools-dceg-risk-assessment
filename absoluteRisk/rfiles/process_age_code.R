#----------------------------------------------------
# Name: process_age_code.R
# Function: check the age inputs 
#
# Inputs: 6 RData file names. Examples:
#    (1) age_start_RData="age_new.RData"
#    (2) age_interval_RData="tau.RData"
#    (3) cov_new_RData="cov_new.RData"
#    (4) snp_info_RData="snp_info.RData"
#    (5) disease_rates_RData="pop_rates.RData"
#    (6) competing_rates_RData="mort_rates_default_US.RData"

# outputs: "NULL" if no errors.
#----------------------------------------------------
#
# Test Code
#
#  > age_start_RData="age_new.RData"
#  > age_interval_RData="tau.RData"
#  > cov_new_RData="cov_new.RData"
#  > snp_info_RData="snp_info.RData"
#  > disease_rates_RData="pop_rates.RData"
#  > competing_rates_RData="mort_rates_default_US.RData"
#  >
#  > source('H:/Rwork/MAAS/process_age_code.R')
#  > process_age_code(age_start_RData, age_interval_RData, cov_new_RData,snp_info_RData, disease_rates_RData, competing_rates_RData)
#    NULL
#
#------------------------------------------------------

source("absolute_risk_code_V4.15.R")
library(MASS)
library(Hmisc)
library(SparseM)
library(Matrix)
library(slam)
library(modeest)

dyn.load("source.dll")


process_age_code <- function(age_start_RData, age_interval_RData, cov_new_RData,snp_info_RData, disease_rates_RData, competing_rates_RData)
{

  	apply.age.start=get(load(age_start_RData)) 
        apply.age.interval.length=get(load(age_interval_RData)) 
        apply.cov.profile=get(load(cov_new_RData))
        apply.snp.profile=get(load(snp_info_RData)) 
        lambda=get(load(disease_rates_RData))
        competing_rates=get(load(competing_rates_RData))
 
        check_age_inputs(apply.age.start, apply.age.interval.length, apply.cov.profile, apply.snp.profile, lambda, competing_rates)
}