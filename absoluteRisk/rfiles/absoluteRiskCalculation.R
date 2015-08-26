# History: May 29, 2015 Added option use.c.code
#          Jun 02, 2015 Updated cutpoints to first round them and then remove duplicates
#          Jun 05, 2015 Added update_cutpoints function to update the cutpoints in case
#                       whe there are no subjects between 2 cutpoints
#          Jun 08, 2015 Reorganized to be more modular, tidied up formatting
#          Jul 02, 2015 Modified for weights

##################################################################################################
#  To compile the c code on UNIX, enter the command "R CMD SHLIB source.c", then a shared library
#    called source.so will be created.
#  To load the shared library, use the dyn.load R function in your R program.
##################################################################################################

## .1 small changes to lines 223, 224, 246, 247

## can handle missing data in profiles for prediction: cov_new.
## can handle multiple time intervals.

## model.cov.info must be a list with the proper formats
#
# apply.age.start=age_new
# apply.age.interval.length=tau
# apply.cov.profile  = cov_new
# model.log.RR = beta_given
# model.disease.incidence.rates = bc_incidence_rates
# model.ref.dataset = risk_factor_distribution
# model.competing.incidence.rates=mortality_rates
# return.lp=F; modify.variables=NULL
# model.cov.info=triple_check
# model.snp.info = snp_info
# apply.snp.profile = genotype_new
# use.c.code=1
# return.refs.risk = F

# #apply.cov.profile [2,2]=NA; apply.cov.profile [4,4]=NA
# apply.cov.profile <-data.frame(  apply.cov.profile [1:4,] )

# apply.age.start<-rep(30,4)
# apply.age.interval.length<-rep(40,4)
# apply.age.start[2]=32
# apply.age.start[4]=34

#' Building and Applying an Absolute Risk Model
#'
#' This function is used to build absolute risk models and apply them to estimate absolute risks.
#'
#' @param model.formula an object of class \code{formula}: a symbolic description of the model to be fitted, e.g. Y~Parity+FamilyHistory.
#' @param model.cov.info contains information about the risk factors in the model ;  a main list containing a list for each covariate, which must have the fields:\cr
#'        \itemize{ \item \code{"name"} : a string with the covariate name, matching name in model.formula \cr
#'        \item \code{"type"} : a string that is either "continuous" or "factor".}
#'        If factor variable, then:\cr
#'        \itemize{\item \code{"levels"} : vector with strings of level names  \cr
#'        \item \code{"ref"} : optional field, string with name of referent level
#'        }
#' @param model.snp.info dataframe with three columns, named: [ "snp.name", "snp.odds.ratio", "snp.freq" ]
#' @param model.log.RR vector with log odds ratios corresponding to the model params; no intercept; names must match design matrix arising from \code{model.formula} and \code{model.cov.info}; check names using function \code{check_design_matrix()}.
#' @param model.ref.dataset dataframe of risk factors for a sample of subjects representative of underlying population, no missing values. Variables must be in same order with same names as in \code{model.formula}.
#' @param model.ref.dataset.weights optional vector of sampling weights for \code{model.ref.dataset}.
#' @param model.disease.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of disease. Must fully cover age interval for estimation.
#' @param model.competing.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of competing events. Must fully cover age interval for estimation.
#' @param model.bin.fh.name string name of family history variable, if in model. This must refer to a variable that only takes values 0,1, NA.
#' @param n.imp integer value for number of imputations for handling missing SNPs.
#' @param apply.age.start single integer or vector of integer ages for the start of the interval over which to compute absolute risk.
#' @param apply.age.interval.length single integer or vector of integer years over which absolute risk should be computed.
#' @param apply.cov.profile dataframe containing the covariate profiles for which absolute risk will be computed. Covariates must be in same order with same names as in \code{model.formula}.
#' @param apply.snp.profile data frame with observed SNP data (coded 0,1, 2, or NA). May have missing values.
#' @param use.c.code binary indicator of whether to run the c program for fast computation.
#' @param return.lp binary indicator of whether to return the linear predictor for each subject in apply.cov.profile.
#' @param return.refs.risk binary indicator of whether to return the absolute risk prediction for each subject in \code{model.ref.dataset}.
#' @details Individualized Coherent Absolute Risk Estimators (iCARE) is a tool that allows researchers to quickly build models for absolute risk and apply them to estimate individuals' risk based on a set of user defined input parameters. The software gives users the flexibility to change or update models rapidly based on new risk factors or tailor models to different populations based on the specification of simply three input arguments: \itemize{ \item (1) a model for relative risk assumed to be externally derived \item (2) an age-specific disease incidence rate and \item (3) the distribution of risk factors for the population of interest.} The tool can handle missing information on risk factors for risk estimation using an approach where all estimates are derived from a single model through appropriate model averaging.
#' @return This function returns a list of results objects, including: \cr
#' \itemize{ \item \code{risk} : absolute risk estimates over the specified interval for subjects given by \code{apply.cov.profile} \cr
#' \item \code{details}: dataframe with the start of the interval, the end of the interval, the covariate profile, and the risk estimates for each individual \cr
#' \item \code{beta.used} : the log odds ratios used in the model \cr
#' \item \code{lps} : linear predictors for subjects in \code{model.cov.profile}, if requested by \code{return.lp} \cr
#' \item \code{refs.risk} : absolute risk estimates for subjects in \code{model.ref.dataset}, if requested by \code{return.refs.risk} }
#' @export
#' @examples
#' results = compute.absolute.risk(model.formula=model.predictor,
#'          model.cov.info=triple_check,
#'          model.snp.info=NULL,
#'          model.log.RR=beta_given,
#'          model.ref.dataset=risk_factor_distribution,
#'          model.ref.dataset.weights = NULL,
#'          model.disease.incidence.rates=bc_incidence_rates,
#'          model.competing.incidence.rates=mortality_rates,
#'          model.bin.fh.name = NULL,
#'          n.imp = 3,
#'          apply.age.start = age_new,
#'          apply.age.interval.length = tau,
#'          apply.cov.profile = cov_new,
#'          apply.snp.profile = NULL,
#'          use.c.code=0)
#'plot(density(results$risk, na.rm=T))
#'boxplot(results$risk ~ cov_new$famhist, na.rm=TRUE)
compute.absolute.risk <- function(model.formula = NULL, model.cov.info = NULL, model.snp.info = NULL, model.log.RR = NULL,
                                  model.ref.dataset = NULL, model.ref.dataset.weights = NULL,
                                  model.disease.incidence.rates,
                                  model.competing.incidence.rates = NULL,
                                  model.bin.fh.name = NA, n.imp = 5,
                                  apply.age.start, apply.age.interval.length,
                                  apply.cov.profile  = NULL,
                                  apply.snp.profile = NULL,
                                  use.c.code = 1,  return.lp = FALSE, return.refs.risk = FALSE){
  #set.seed(3948792)
  decision      <- decide_if_SNP_only(apply.cov.profile, model.formula, model.log.RR, model.ref.dataset, model.cov.info, model.snp.info, apply.snp.profile, apply.age.start, apply.age.interval.length)
  covs_in_model <-  decision[[1]]
  if(length(decision)>1) apply.snp.profile   <-  decision[[2]]
  
  
  handle.snps = 1 - is.null(model.snp.info)
  
  if (covs_in_model) {
    temp         <- check_age_lengths(apply.age.start, apply.age.interval.length, apply.cov.profile , "apply.cov.profile ")
    apply.age.start      <- temp[[1]]
    apply.age.interval.length <- temp[[2]]
    
    temp         <- check_model_inputs(apply.cov.profile , model.log.RR, model.ref.dataset, model.ref.dataset.weights, model.cov.info, model.formula, n.imp)
    data_use     <- temp[[1]]
    model.log.RR   <- temp[[2]]
    model.ref.dataset.weights <- temp[[3]]
    
    design_covs <- make_design_matrix_covs(data_use, apply.cov.profile, model.formula)
    
    check_design_matrix(model.log.RR, design_covs)
    Z_new        <- t(design_covs); rm(design_covs); gc()
    beta_est     <- as.matrix(nrow = length(model.log.RR), ncol=1, model.log.RR)
    pop.dist.mat <- make_design_matrix_dist(data_use, model.ref.dataset, model.formula)
    pop.weights  <- model.ref.dataset.weights
  }
  
  if(handle.snps){
    
    check_SNP_info(model.snp.info)
    
    snps.names <- paste(model.snp.info[,"snp.name"])
    snps.betas <- log( model.snp.info[,"snp.odds.ratio"] )
    snps.freqs <- model.snp.info[,"snp.freq"]
    
    processed_info = process_SNP_info(covs_in_model, apply.snp.profile, model.bin.fh.name, apply.cov.profile , model.ref.dataset, model.snp.info)
    
    attenuate.fh  <-  processed_info[[1]]
    fh.pop        <-  processed_info[[2]]
    fh.cov        <-  processed_info[[3]]
    apply.snp.profile  <-  processed_info[[4]]
  }
  
  if (covs_in_model) {
    
    if(handle.snps){
      # covariate_stack5 <- rbind(pop.dist.mat, pop.dist.mat, pop.dist.mat, pop.dist.mat, pop.dist.mat)
      covariate_stack5 <- do.call("rbind", replicate(n.imp, pop.dist.mat, simplify = FALSE))
      simulated_snps   <- sim_snps(snps.betas, snps.freqs, cbind( rep( fh.pop, n.imp)) )
      pop.dist.mat     <- cbind( simulated_snps, covariate_stack5 )
      pop.weights      <- rep( model.ref.dataset.weights, n.imp )
      
      if(attenuate.fh){
        var_prs <- sum((snps.betas^2)*2*snps.freqs*(1-snps.freqs))
        alpha   <- var_prs/2
        if(model.cov.info[[which(model.bin.fh.name==colnames(apply.cov.profile ))]]$type=="factor"){
          model.bin.fh.name = paste("as.factor(", model.bin.fh.name, ")1", sep="")
        }
        beta_est[model.bin.fh.name,1] <- beta_est[model.bin.fh.name,1] - alpha
      }
      beta_est <- as.matrix(nrow = length(c( snps.betas, beta_est)), ncol = 1, c( snps.betas, beta_est) )
      Z_new    <- rbind(t(apply.snp.profile), Z_new)
    }
  } else {
    temp         <- check_age_lengths(apply.age.start, apply.age.interval.length, apply.snp.profile, "apply.snp.profile")
    apply.age.start      <- temp[[1]]
    apply.age.interval.length <- temp[[2]]
    
    if(handle.snps){
      pop.dist.mat <- sim_snps(snps.betas, snps.freqs, cbind( rep( fh.pop, n.imp)) )
      pop.weights  <- rep( 1/nrow(pop.dist.mat), nrow(pop.dist.mat) )
      beta_est     <- as.matrix(nrow = length(c( snps.betas)), ncol = 1, c( snps.betas) )
      Z_new        <- t(apply.snp.profile)
    }
  }
  lambda                    <- model.disease.incidence.rates; rm(model.disease.incidence.rates)
  res                       <- check_rates(model.competing.incidence.rates, lambda, apply.age.start, apply.age.interval.length)
  lambda                    <- res[[1]]
  model.competing.incidence.rates <- res[[2]]; rm(res)
  approx_expectation_rr     <- weighted.mean(  exp( pop.dist.mat%*% beta_est), w = pop.weights, na.rm=T)
  calculation               <- precise_lambda0(lambda, approx_expectation_rr, beta_est, pop.dist.mat, pop.weights)
  lambda_0                  <- calculation[[1]]
  precise_expectation_rr    <- calculation[[2]]
  pop.dist.mat              <- t(pop.dist.mat )
  
  ###### Compute A_j  ## only those without NA
  final_risks <- rep(NA, ncol(Z_new))
  lps <- t(Z_new)%*%beta_est
  these = which(colSums( is.na(Z_new))==0 )
  
  if( length(these) > 0 ){
    temp               <- subset(Z_new, select=these)
    final_risks[these] <- comp_Aj(temp, apply.age.start[these], apply.age.interval.length[these], lambda_0, beta_est, model.competing.incidence.rates)
  }
  miss    <- which(is.na(final_risks))
  present <- which(!is.na(final_risks))
  ref_pop <- pop.dist.mat;
  ncuts   <- 100
  t00     <- proc.time()
  
  temp = 0
  if(!is.null(apply.snp.profile)){
    temp = sum(!is.na(apply.snp.profile))
  }
  
  if(!covs_in_model & handle.snps & (temp==0)){ # snp only model with no genotypes provided
    res = get_refs_risk(ref_pop, apply.age.start, apply.age.interval.length, lambda_0, beta_est, model.competing.incidence.rates, handle.snps, n.imp )
    samp = sample(seq(1, length(res[[1]])), size=nrow(apply.snp.profile), replace=T)
    final_risks <- res[[1]][samp]
    lps         <- res[[2]][samp]
  }else{
    if(!handle.snps){
      res         <- handle_missing_data(use.c.code, apply.age.start, apply.age.interval.length, Z_new, miss, present, ncuts, final_risks, ref_pop, pop.weights, lambda_0, beta_est, model.competing.incidence.rates, lps)
      final_risks <- res[[1]]
      lps         <- res[[2]]
    } else {
      set = rep(F, nrow(apply.snp.profile))
      set[miss]=T
      miss_w_all_SNPs_present <- miss[ which( rowSums(is.na(subset(apply.snp.profile, subset=set)))==0 )]
      miss_w_some_SNPs_miss   <- miss[ which( rowSums(is.na(subset(apply.snp.profile, subset=set)))>0 ) ]
      
      if (length(miss_w_all_SNPs_present) > 0) {
        res         <- handle_missing_data(use.c.code, apply.age.start, apply.age.interval.length, Z_new, miss_w_all_SNPs_present, setdiff(seq(1, nrow(apply.cov.profile )), miss_w_all_SNPs_present), ncuts, final_risks, ref_pop, pop.weights, lambda_0, beta_est, model.competing.incidence.rates, lps)
        final_risks <- res[[1]]
        lps         <- res[[2]]
      }
      if (length(miss_w_some_SNPs_miss) > 0) {
        res         <- handle_missing_data(use.c.code, apply.age.start, apply.age.interval.length, Z_new, miss_w_some_SNPs_miss, setdiff(seq(1, nrow(apply.cov.profile )), miss_w_some_SNPs_miss), ncuts, final_risks, ref_pop, pop.weights, lambda_0, beta_est, model.competing.incidence.rates, lps)
        final_risks <- res[[1]]
        lps         <- res[[2]]
      }
    }
    if(covs_in_model){
      final_risks[which(colSums(!is.na(Z_new))==0)] <- NA # nothing to match on w referent dataset, report NA
    }
  }
  t11    <- proc.time() - t00;  print(t11)
  result <- package_results(final_risks, Z_new, covs_in_model, handle.snps, apply.age.start, apply.age.interval.length, apply.cov.profile , model.log.RR, beta_est, apply.snp.profile, snps.names, return.lp, lps)
  if(return.refs.risk) result$refs.risk <- get_refs_risk(ref_pop, apply.age.start, apply.age.interval.length, lambda_0, beta_est, model.competing.incidence.rates, handle.snps, n.imp )[[1]]
  result
}

############################################################################################
#####  Begin Helper Functions #####
############################################################################################

# lambda should be matrix of two columns (age, incidence rates ) diff ages in the rows

pick_lambda <- function(t, lambda){
  
  a <- which(t==lambda[,1])
  lambda[a,2]
}

# c should be a two column matrix with first column times

# computes internal integral over u for estimate of A_j
get_int <- function(a,t,lambda, Z_new, beta_est, model.competing.incidence.rates, ZBETA = NULL){
  
  holder<-0
  if (is.null(ZBETA)) {
    ZBETA <- t(exp(t(Z_new)%*%beta_est))
  }
  
  for(u in min(a, na.rm = T):max(t, na.rm = T)){
    temp0  <- (u>=a)*(u<t)
    holder <- holder + temp0*( (pick_lambda(u,lambda))*ZBETA + model.competing.incidence.rates[which(u==model.competing.incidence.rates[,1]),2])
  }
  holder
}

get_beta_given_names <-function(model.cov.info, model.formula){
  
  check_triple_check(model.cov.info)
  model.cov.info = process_triple_check(model.cov.info)
  
  if(is.null(colnames(model.cov.info))){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  if(length(colnames(model.cov.info))!=length(all.vars(model.formula)[2:length(all.vars(model.formula))])){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  if( sum(colnames(model.cov.info)!=all.vars(model.formula)[2:length(all.vars(model.formula))])>0 ){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  variables <- unique(all.vars(model.formula))[-1]
  data_use  <- subset(model.cov.info, select = variables)
  data_use[,all.vars(model.formula)[1]] <- rep(0, nrow(data_use))
  predictors <- as.matrix(model.matrix(model.formula, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.formula, data = as.data.frame(data_use)))])
  colnames(predictors)
  
}

###  make design matrix for apply.cov.profile
make_design_matrix_covs <- function(data_use, apply.cov.profile, model.formula){
  
  options(na.action='na.pass')
  init_n   <- nrow(data_use)
  jump_cov <- nrow(apply.cov.profile )
  
  data_use   <- rbind(data_use, apply.cov.profile )
  data_use[,all.vars(model.formula)[1]] <- rep(0, nrow(data_use))
  
  predictors <- as.matrix(model.matrix(model.formula, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.formula, data = as.data.frame(data_use)))])
  set        <- rep(F, nrow(predictors))
  set[(init_n+1):(init_n+jump_cov)]=T
  apply.cov.profile     <- subset( predictors, subset = set)
  apply.cov.profile
}

###  make design matrix for model.ref.dataset
make_design_matrix_dist <- function(data_use, model.ref.dataset, model.formula){
  
  init_n   <- nrow(data_use)
  jump_cov <- nrow(model.ref.dataset)
  
  data_use <- rbind(data_use, model.ref.dataset)
  data_use <- cbind(data_use, rep(0, nrow(data_use)))
  colnames(data_use) <- c(colnames(data_use)[1:(length(colnames(data_use))-1)],  all.vars(model.formula)[1])
  
  predictors   <- as.matrix(model.matrix(model.formula, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.formula, data = as.data.frame(data_use)))])
  pop.dist.mat <- predictors[(init_n+1):(init_n+jump_cov),]
  cbind(pop.dist.mat)
}

###### Compute Absolute Risk
comp_Aj <- function(Z_new, apply.age.start, apply.age.interval.length, lambda, beta_est, model.competing.incidence.rates){
  
  ZBETA <- t(exp(t(beta_est)%*%Z_new))
  avec  <- apply.age.start + apply.age.interval.length
  tvec  <- min(apply.age.start, na.rm = T):max(avec, na.rm = T)
  temp  <- match(tvec, lambda[,1])
  c2    <- t(Z_new)%*%beta_est
  c3    <- log(lambda[temp, 2])
  
  Aj_est <- rep(0, ncol(Z_new))
  for(i in 1:length(tvec)){
    t         <- tvec[i]
    temp      <- get_int(apply.age.start,t,lambda, Z_new, beta_est, model.competing.incidence.rates, ZBETA = ZBETA)
    this_year <- (t >= apply.age.start)*(t < avec)*exp(c3[i] + c2 - temp)
    
    Aj_est    <- Aj_est + this_year
  }
  Aj_est
}

### iterate to obtain lambda_0
precise_lambda0 <- function(lambda, approx_expectation_rr, beta_est, pop.dist.mat, pop.weights){
  diagnose                <- list()
  lambda_0                <- lambda
  precise_expectation_rr0 <- approx_expectation_rr-1
  precise_expectation_rr1 <- approx_expectation_rr
  iter                    <- 0
  while( sum(abs(precise_expectation_rr1 - precise_expectation_rr0 )) >0.001 ){
    
    iter = iter+1
    precise_expectation_rr0 = precise_expectation_rr1
    diagnose[[iter]]=precise_expectation_rr0
    # new expectation rr implies lambda0
    lambda_0[,2] = lambda[,2] / precise_expectation_rr0
    # that lambda0 implies new expectation rr
    # this should be Nobs x Ntimes
    this = survival_givenX(lambda_0, beta_est, pop.dist.mat)*matrix(nrow=nrow(pop.dist.mat), ncol=nrow(lambda_0), pop.weights, byrow=T)
    denom = 1/colSums(this)
    probX_givenT = sweep( this, MARGIN = 2, denom, FUN="*" )
    
    # to compute next iteration
    precise_expectation_rr1 = colSums( sweep( probX_givenT, MARGIN = 1,  exp( pop.dist.mat %*% beta_est ), FUN="*") )
  }
  lambda_0[,2] = lambda[,2] / precise_expectation_rr1
  res = list();  res[[1]] = lambda_0;  res[[2]] = precise_expectation_rr1; res[[3]]=diagnose
  res
}

### getting lambda_0 iteratively
survival_givenX <- function(lambda_0, beta_est, pop.dist.mat){ # must produce matrix with Nobs x Ntimes
  
  ## cumulative up to but not including current time
  mult   <- -exp( pop.dist.mat %*% beta_est )
  cumLam <- cumsum( c(0,lambda_0[,2]) )[1:length(lambda_0[,2])]
  exp( mult %*% cumLam  )
}

## correct sweep example
# mat <- matrix(rep(1:3,each<-5),nrow=3,ncol=5,byrow=TRUE)
# vec <- 1:5
# sweep(mat,MARGIN=2,vec,`*`)

## transform model.cov.info into a form easily usable in the function
process_triple_check <- function(model.cov.info){
  maximum_dim = 0
  for(i in 1:length(model.cov.info)){
    maximum_dim = max(maximum_dim, length(model.cov.info[[i]]$levels) )
  }
  matt = data.frame(starter_column = rep(0, maximum_dim))
  
  for(i in 1:length(model.cov.info)){
    
    if(model.cov.info[[i]]$type == "continuous"){
      matt[,model.cov.info[[i]]$name] = rep(0,maximum_dim)
    }
    if(model.cov.info[[i]]$type == "factor"){
      matt[,model.cov.info[[i]]$name] = factor( c(model.cov.info[[i]]$levels, rep(model.cov.info[[i]]$levels[1], maximum_dim - length(model.cov.info[[i]]$levels))), levels = unique(c(model.cov.info[[i]]$levels, rep(model.cov.info[[i]]$levels[1], maximum_dim - length(model.cov.info[[i]]$levels)))))
      ### if there is a referent level specified, recode that way
      if(is.null(model.cov.info[[i]]$ref)==FALSE){
        matt[,model.cov.info[[i]]$name] = relevel(matt[,model.cov.info[[i]]$name], ref = as.character(model.cov.info[[i]]$ref))
      }
    }
  }
  matt[,1] <- NULL
  matt
}

## verify that model.cov.info is in the proper form
check_triple_check <- function(model.cov.info){
  
  if( is.list(model.cov.info)!=TRUE){
    return_and_print("ERROR: model.cov.info must be a list.")
    stop()
  }
  for(i in 1:length(model.cov.info)){
    if( is.list(model.cov.info[[i]])!=TRUE ){
      return_and_print("ERROR: Each element of model.cov.info must be a list (that contains the information for a variable). ")
      stop()
    }
    if( is.null(model.cov.info[[i]]$name) ){
      return_and_print("ERROR: Each list within model.cov.info describing a variable must have a 'name' field. ")
      stop()
    }
    if( is.null(model.cov.info[[i]]$type) ){
      return_and_print("ERROR: Each list within model.cov.info describing a variable must have a 'type' field. ")
      stop()
    }}
  for(i in 1:length(model.cov.info)){
    
    if( model.cov.info[[i]]$type == "continuous"  & is.null(model.cov.info[[i]]$levels)!=TRUE){
      print(paste("WARNING: You have specified that the variable '", model.cov.info[[i]]$name, "' is continuous, so the 'levels' input for that variable is not needed and will not be used.", sep="") )
    }# allow to continue
    if( model.cov.info[[i]]$type == "factor"  & is.null(model.cov.info[[i]]$levels)==TRUE){
      return_and_print(paste("ERROR: You must specify the 'levels' field of the variable '", model.cov.info[[i]]$name, "', because you gave its type to be 'factor'.", sep="") )
      stop()
    }
    if( model.cov.info[[i]]$type == "factor"  & is.null(model.cov.info[[i]]$levels)==FALSE){
      if(is.vector(model.cov.info[[i]]$levels)!=TRUE ){
        return_and_print(paste("ERROR: You must specify the 'levels' field of the variable '", model.cov.info[[i]]$name, "', as a vector.", sep="") )
        stop()
      }
      if(is.null(model.cov.info[[i]]$ref)==FALSE){
        if(is.element(model.cov.info[[i]]$ref, model.cov.info[[i]]$levels)==FALSE){
          return_and_print(paste("ERROR: The 'ref' field of the variable '", model.cov.info[[i]]$name, "' must specify a referent level that is contained in the 'levels' field for that variable.", sep="") )
          stop()
        }
      }
    }
  }
}
## helper function
## creates model.cov.info from a dataframe
## option to flag factor variables by including a vector of Variable names
## if factor_vars input is not provided, then considered continuous if more than 12 unique levels, else factor
make_triple_check <- function(frame, factor_vars = NULL){
  
  if( !is.data.frame(frame) ){
    return_and_print("ERROR: input must be a dataframe")
    stop()
  }
  
  the_names = colnames(frame)
  model.cov.info = list()
  length(model.cov.info)=length(the_names)
  
  if(is.null(factor_vars)==FALSE){
    if(is.vector(factor_vars)!=TRUE ){
      return_and_print(paste("ERROR: The optional 'flag' of factor variables must be specified as a vector.", sep="") )
      stop()
    }
    if( prod( is.element(factor_vars, the_names)) == 0 ){
      return_and_print(paste("ERROR: The optional 'flag' of factor variables must contain names that match the column names of the dataframe.", sep="") )
      stop()
    }
  }
  
  for(i in 1:ncol(frame)){
    
    temp = list()
    temp$name = the_names[i]
    ###
    if(is.null(factor_vars)==FALSE){
      toggle = !is.element(temp$name, factor_vars)
    }
    if(is.null(factor_vars)){
      # binary indicator of whether the variable is continuous
      toggle = length(c(unique(frame[,i])))>12
      if( is.factor(frame[,13]) ==TRUE ){
        toggle = FALSE
      }
    }###
    if(toggle){
      temp$type = "continuous"
    }
    if(toggle == FALSE){
      temp$type = "factor"
      temp$levels = c(unique(frame[,i]))
      temp$ref = temp$levels[1]
    }
    model.cov.info[[i]]=temp
  }
  model.cov.info
}

## Function for combining Absolute Risks for Adjacent Intervals
combine_risks_two_intervals <- function(age_start_1, age_interval_1, absolute_risks_1, age_start_2, age_interval_2,
                                        absolute_risks_2){
  
  if( sum(age_start_1 + age_interval_1 != age_start_2) >0 ){
    return_and_print(paste("ERROR: To combine risks for two intervals, they must be adjacent.", sep="") )
    stop()
  }
  
  overall_age_start = age_start_1
  overall_age_interval = age_interval_1 + age_interval_2
  overall_absolute_risks =  absolute_risks_1 + (1 - absolute_risks_1)*absolute_risks_2
  
  result = list()
  result$details = cbind(overall_age_start, overall_age_interval, overall_absolute_risks)
  result$risk = cbind(overall_absolute_risks)
  result
}

## helper function for computing absolute risk of competing mortality
comp_AR_compete <- function(apply.age.start, apply.age.interval.length, model.competing.incidence.rates){
  ###### Compute A_j
  
  Aj_est <- 0
  for(t in min(apply.age.start, na.rm = T):max(apply.age.start+apply.age.interval.length, na.rm = T)){
    
    this_year <- (t>=apply.age.start)*(t<apply.age.start+apply.age.interval.length)*exp( log(pick_lambda(t, model.competing.incidence.rates)) - get_int_compete(apply.age.start,t, model.competing.incidence.rates) )#ex[t-apply.age.start+1]=Aj_est
    Aj_est    <- Aj_est + this_year
  }
  Aj_est
}

## helper function for computing survival of competing risk
get_int_compete <- function(a,t,model.competing.incidence.rates){
  
  holder <- 0
  for(u in min(a, na.rm = T):max(t, na.rm = T)){
    holder <- holder+(u>=a)*(u<t)*model.competing.incidence.rates[which(u==model.competing.incidence.rates[,1]),2]
  }
  holder
}

#' Building and Applying an Absolute Risk Model:  Compute Risk over Interval Split in Two Parts
#'
#' This function is used to build an absolute risk model that incorporates different input parameters before and after a given time point. The model is then applied to estimate absolute risks.
#'
#' @param apply.age.start single integer or vector of integer ages for the start of the interval over which to compute absolute risk.
#' @param apply.age.interval.length single integer or vector of integer years over which absolute risk should be computed.
#' @param apply.cov.profile dataframe containing the covariate profiles for which absolute risk will be computed. Covariates must be in same order with same names as in \code{model.formula}.
#' @param model.formula an object of class \code{formula}: a symbolic description of the model to be fitted, e.g. Y~Parity+FamilyHistory.
#' @param model.disease.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of disease. Must fully cover age interval for estimation.
#' @param model.log.RR vector with log odds ratios corresponding to the model params; no intercept; names must match design matrix arising from \code{model.formula} and \code{model.cov.info}; check names using function \code{check_design_matrix()}.
#' @param model.ref.dataset dataframe of risk factors for a sample of subjects representative of underlying population, no missing values. Variables must be in same order with same names as in \code{model.formula}.
#' @param model.ref.dataset.weights optional vector of sampling weights for \code{model.ref.dataset}.
#' @param model.cov.info contains information about the risk factors in the model ;  a main list containing a list for each covariate, which must have the fields:\cr
#'        \itemize{ \item \code{"name"} : a string with the covariate name, matching name in model.formula \cr
#'        \item \code{"type"} : a string that is either "continuous" or "factor".}
#'        If factor variable, then:\cr
#'        \itemize{\item \code{"levels"} : vector with strings of level names  \cr
#'        \item \code{"ref"} : optional field, string with name of referent level
#'        }
#' @param use.c.code binary indicator of whether to run the c program for fast computation.
#' @param model.competing.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of competing events. Must fully cover age interval for estimation.
#' @param return.lp binary indicator of whether to return the linear predictor for each subject in apply.cov.profile.
#' @param apply.snp.profile data frame with observed SNP data (coded 0,1, 2, or NA). May have missing values.
#' @param model.snp.info dataframe with three columns [ rs number, odds ratio, allele frequency ]
#' @param model.bin.fh.name string name of family history variable, if in model. This must refer to a variable that only takes values 0,1, NA.
#' @param apply.snp.profile data frame with observed SNP data (coded 0,1, 2, or NA). May have missing values.
#' @param cut.time integer age for which to split computation into before and after
#' @param apply.cov.profile.2 see \code{apply.cov.profile}, to be used for estimation in ages after the cutpoint
#' @param model.formula.2 see \code{model.formula}, to be used for estimation in ages after the cutpoint
#' @param model.log.RR.2 see \code{model.log.RR}, to be used for estimation in ages after the cutpoint
#' @param model.ref.dataset.2 see \code{model.ref.dataset}, to be used for estimation in ages after the cutpoint
#' @param model.ref.dataset.weights.2 see \code{model.ref.dataset.weights}, to be used for estimation in ages after the cutpoint
#' @param model.cov.info.2 see \code{model.cov.info}, to be used for estimation in ages after the cutpoint
#' @param model.bin.fh.name.2 see \code{model.bin.fh.name}, to be used for estimation in ages after the cutpoint
#' @param n.imp integer value for number of imputations for handling missing SNPs.
#' @details Individualized Coherent Absolute Risk Estimators (iCARE) is a tool that allows researchers to quickly build models for absolute risk and apply them to estimate individuals' risk based on a set of user defined input parameters. The software gives users the flexibility to change or update models rapidly based on new risk factors or tailor models to different populations based on the specification of simply three input arguments: \itemize{ \item (1) a model for relative risk assumed to be externally derived \item (2) an age-specific disease incidence rate and \item (3) the distribution of risk factors for the population of interest.} The tool can handle missing information on risk factors for risk estimation using an approach where all estimates are derived from a single model through appropriate model averaging.
#' @return This function returns a list of results objects, including: \cr
#' \itemize{ \item \code{risk} : absolute risk estimates over the specified interval for subjects given by \code{apply.cov.profile} \cr
#' \item \code{details}: dataframe with the start of the interval, the end of the interval, the covariate profile, and the risk estimates for each individual \cr
#' \item \code{beta.used} : the log odds ratios used in the model \cr
#' \item \code{lps} : linear predictors for subjects in \code{model.cov.profile}, if requested by \code{return.lp} \cr
#' \item \code{refs.risk} : absolute risk estimates for subjects in \code{model.ref.dataset}, if requested by \code{return.refs.risk} }
#' @export
#' @examples
#' print("Hello world")
#' 
#' 
compute.absolute.risk.split.interval <- function(apply.age.start, apply.age.interval.length, apply.cov.profile, model.formula, model.disease.incidence.rates,
                                                 model.log.RR, model.ref.dataset, model.ref.dataset.weights=NULL, model.cov.info, use.c.code=1, model.competing.incidence.rates = NULL,
                                                 return.lp = FALSE, apply.snp.profile = NULL, model.snp.info = NULL, model.bin.fh.name = NULL, cut.time = NULL, apply.cov.profile.2 = NULL,
                                                 model.formula.2 = NULL, model.log.RR.2 = NULL, model.ref.dataset.2 = NULL, model.ref.dataset.weights.2 = NULL, model.cov.info.2 = NULL, model.bin.fh.name.2 = NULL, n.imp = 5, return.refs.risk=FALSE){
  
  ## if any of the second arguments are specified, then two two version
  if( is.null( cut.time )*is.null( apply.cov.profile.2 )*is.null( model.formula.2 )*is.null( model.log.RR.2 )*is.null( model.ref.dataset.2 )*is.null( model.cov.info.2 ) ==0 ){
    
    if(is.null( cut.time )){
      return_and_print(paste("ERROR: If you wish to use different model inputs over parts of the age interval, must specify cut.time.", sep="") )
      stop()
    }
    if( sum( (cut.time < apply.age.start) + (cut.time > apply.age.start + apply.age.interval.length) ) >0 ){
      print(paste("Note: You provided cut.times outside the interval defined by apply.age.start and apply.age.interval.length.  Will compute risk using either inputs1 or inputs2 only, depending on whether the interval is below or above the cutpoint.", sep="") )
    }
    ## for the rest, if not specified use originals
    if(is.null( apply.cov.profile.2 )){
      apply.cov.profile.2 = apply.cov.profile
    }
    if(is.null( model.formula.2 )){
      model.formula.2 = model.formula
    }
    
    if(is.null( model.log.RR.2 )){
      model.log.RR.2 = model.log.RR
    }
    if(is.null( model.ref.dataset.2 )){
      model.ref.dataset.2 = model.ref.dataset
    }
    if(is.null( model.cov.info.2 )){
      model.cov.info.2 = model.cov.info
    }
    if(is.null( model.bin.fh.name.2 )){
      model.bin.fh.name.2 = model.bin.fh.name
    }
    
    apply.age.start.1 = apply.age.start
    apply.age.interval.length.1 = (cut.time - apply.age.start)*( (cut.time - apply.age.start) < apply.age.interval.length) +   (apply.age.interval.length)*( 1 - ( (cut.time - apply.age.start) < apply.age.interval.length))
    apply.age.interval.length.1[which(apply.age.interval.length.1<0)]=0
    
    apply.age.start.2 = apply.age.start.1 + apply.age.interval.length.1
    apply.age.interval.length.2 = apply.age.start + apply.age.interval.length - apply.age.start.2
    
    result1 = compute.absolute.risk(apply.age.start=apply.age.start.1, apply.age.interval.length=apply.age.interval.length.1, apply.cov.profile=apply.cov.profile  , model.formula=model.formula,   model.disease.incidence.rates=model.disease.incidence.rates, model.log.RR=model.log.RR,    model.ref.dataset=model.ref.dataset,   model.ref.dataset.weights=model.ref.dataset.weights,  model.cov.info=model.cov.info,   use.c.code=use.c.code, model.competing.incidence.rates=model.competing.incidence.rates, return.lp=return.lp, apply.snp.profile = apply.snp.profile, model.snp.info = model.snp.info,  model.bin.fh.name = model.bin.fh.name,  n.imp = n.imp, return.refs.risk=return.refs.risk )
    result2 = compute.absolute.risk(apply.age.start=apply.age.start.2, apply.age.interval.length=apply.age.interval.length.2, apply.cov.profile=apply.cov.profile.2, model.formula=model.formula.2, model.disease.incidence.rates=model.disease.incidence.rates, model.log.RR=model.log.RR.2, model.ref.dataset=model.ref.dataset.2, model.ref.dataset.weights=model.ref.dataset.weights.2, model.cov.info=model.cov.info.2, use.c.code=use.c.code, model.competing.incidence.rates=model.competing.incidence.rates, return.lp=return.lp, apply.snp.profile = apply.snp.profile, model.snp.info = model.snp.info,  model.bin.fh.name = model.bin.fh.name.2, n.imp = n.imp, return.refs.risk=return.refs.risk )
    
    result = combine_risks_two_intervals(result1$details[,"Int_Start"], result1$details[,"Int_End"] - result1$details[,"Int_Start"], result1$details[,"Risk_Estimate"], result2$details[,"Int_Start"], result2$details[,"Int_End"] - result2$details[,"Int_Start"], result2$details[,"Risk_Estimate"])
    result$details = cbind(apply.age.start.1, apply.age.start.2, apply.age.start.2 + apply.age.interval.length.2, apply.cov.profile , apply.cov.profile.2, result$risk)
    if(return.lp){
      result$lps.1 = result1$lps
      result$lps.2 = result2$lps
    }
    if(return.refs.risk){
      result$refs.risk.1 = result1$refs.risk
      result$refs.risk.2 = result2$refs.risk}
  }
  else{  # just run standard function
    result = compute.absolute.risk(apply.age.start=apply.age.start, apply.age.interval.length=apply.age.interval.length, apply.cov.profile=apply.cov.profile , model.formula=model.formula, model.disease.incidence.rates=model.disease.incidence.rates, model.log.RR=model.log.RR, model.ref.dataset=model.ref.dataset, model.ref.dataset.weights=model.ref.dataset.weights, model.cov.info=model.cov.info, use.c.code=use.c.code, model.competing.incidence.rates=model.competing.incidence.rates, return.lp=return.lp, apply.snp.profile = apply.snp.profile, model.snp.info = model.snp.info, model.bin.fh.name = model.bin.fh.name, n.imp = n.imp)
  }
  
  result
}

call_c1 <- function(final, lps, ref_full_LP, miss, ref_risks, refmat, betavec, zmat, pop.weights, ncuts = 100, debug = 0) {
  
  
  DMISS            <- 999999999.9
  DMISS_TEST       <- 999999999.0
  zmat             <- zmat[, miss, drop = FALSE]
  temp             <- !is.finite(zmat)
  zmat[temp]       <- DMISS
  temp             <- !is.finite(ref_risks)
  ref_risks[temp]  <- DMISS
  temp             <- !is.finite(refmat)
  refmat[temp]     <- DMISS
  n_beta           <- length(betavec)
  probs            <- seq(0, 1, 1/ncuts)
  n_probs          <- length(probs)
  nr_z             <- ncol(zmat)
  nc_z             <- nrow(zmat)
  nr_ref           <- ncol(refmat)
  nc_ref           <- nrow(refmat)
  retvec           <- rep(DMISS, length(miss))
  retlps           <- rep(DMISS, length(miss))
  retflag          <- 1
  dim(ref_full_LP) <- NULL
  
  temp <- .C("ref_risk1", as.numeric(ref_risks), as.numeric(betavec), as.numeric(t(zmat)),
             as.numeric(t(refmat)), as.integer(n_beta), as.integer(nr_z), as.integer(nc_z),
             as.integer(nr_ref), as.integer(nc_ref), as.numeric(probs), as.integer(n_probs),
             as.integer(debug), as.numeric(pop.weights), as.double(ref_full_LP),
             retvec = as.numeric(retvec), retflag = as.integer(retflag), retlps=as.numeric(retlps))
  
  retflag <- temp$retflag
  if (retflag) stop("ERROR in c code")
  retvec  <- temp$retvec
  retlps  <- temp$retlps
  temp    <- retvec > DMISS_TEST
  if (any(temp)) retvec[temp] <- NA
  temp    <- retlps > DMISS_TEST
  if (any(temp)) retlps[temp] <- NA
  
  final[miss] <- retvec
  lps[miss]   <- retlps
  
  list(final=final, lps=lps)
  
} # END: call_c1

call_c2 <- function(final, lps, ref_full_LP, miss, refmat, betavec, zmat, age_new, age_int, popSubFromLP,
                    lambda_0, compRates0, pop.weights, ncuts = 100, debug = 0) {
  
  DMISS            <- 999999999.9
  DMISS_TEST       <- 999999999.0
  zmat             <- zmat[, miss, drop = FALSE]
  temp             <- !is.finite(zmat)
  zmat[temp]       <- DMISS
  temp             <- !is.finite(refmat)
  refmat[temp]     <- DMISS
  n_beta           <- length(betavec)
  probs            <- seq(0, 1, 1/ncuts)
  n_probs          <- length(probs)
  nr_z             <- ncol(zmat)
  nc_z             <- nrow(zmat)
  nr_ref           <- ncol(refmat)
  nc_ref           <- nrow(refmat)
  retvec           <- rep(DMISS, length(miss))
  retlps           <- rep(DMISS, length(miss))
  retflag          <- 1
  dim(ref_full_LP) <- NULL
  
  age_new         <- age_new[miss]
  age_int         <- age_int[miss]
  
  # Get all values of age
  temp                         <- c(age_new, age_new+age_int)
  maxa                         <- max(temp)
  n_lambda                     <- maxa + 1
  lambda                       <- rep(0, n_lambda)
  lambda[lambda_0[, 1]+1]      <- lambda_0[, 2]
  compRates                    <- rep(0, n_lambda)
  compRates[compRates0[, 1]+1] <- compRates0[, 2]
  temp                         <- is.na(compRates)
  compRates[temp]              <- DMISS
  
  temp <- .C("ref_risk2", as.numeric(betavec), as.numeric(t(zmat)), as.numeric(t(refmat)),
             as.integer(n_beta), as.integer(nr_z), as.integer(nc_z), as.integer(nr_ref),
             as.integer(nc_ref), as.numeric(probs), as.integer(n_probs), as.integer(debug),
             as.integer(age_new), as.integer(age_int), as.integer(n_lambda), as.numeric(popSubFromLP),
             as.numeric(lambda), as.numeric(compRates), as.numeric(pop.weights), as.double(ref_full_LP),
             retvec = as.numeric(retvec), retflag = as.integer(retflag), retlps=as.numeric(retlps))
  
  retflag <- temp$retflag
  if (retflag) stop("ERROR in c code")
  retvec  <- temp$retvec
  retlps  <- temp$retlps
  temp    <- retvec > DMISS_TEST
  if (any(temp)) retvec[temp] <- NA
  temp    <- retlps > DMISS_TEST
  if (any(temp)) retlps[temp] <- NA
  
  final[miss] <- retvec
  lps[miss]   <- retlps
  
  list(final=final, lps=lps)
  
} # END: call_c2

sim_snps <- function(betas, freqs, fh_status){
  
  snps <- matrix( NA, ncol = length(betas), nrow = length(fh_status))
  
  prob012_fh_no = cbind( (1-freqs)^2, 2*freqs*(1-freqs), freqs^2)
  
  beta_mat = matrix( betas, nrow = length(betas), ncol = 3, byrow = F)
  top = exp( beta_mat*matrix(c(0,1,2), nrow = length(betas), ncol = 3, byrow = T)/2 )*matrix(prob012_fh_no, nrow = length(betas), ncol = 3, byrow = F)
  bottom = matrix(rowSums(top), nrow =length(betas), ncol = 3, byrow = F)
  
  prob012_fh_yes = top/bottom
  
  fh_no  <- which(fh_status==0)
  fh_yes <- which(fh_status==1)
  
  vals = matrix( runif(length(betas)*length(fh_status)), ncol = length(betas), nrow = length(fh_status))
  
  if(length(fh_no)>0){
    snps[fh_no,] =  ( vals[fh_no,] > matrix(prob012_fh_no[,1], nrow = length(fh_no), ncol = length(prob012_fh_no[,1]), byrow = T ) ) + ( vals[fh_no,] > matrix(rowSums(subset(prob012_fh_no, select=1:2)), nrow = length(fh_no), ncol = length(prob012_fh_no[,1]), byrow = T ) )
  }
  if(length(fh_yes)>0){
    snps[fh_yes,] =  ( vals[fh_yes,] > matrix(prob012_fh_yes[,1], nrow = length(fh_yes), ncol = length(prob012_fh_yes[,1]), byrow = T ) ) + ( vals[fh_yes,] > matrix(rowSums(subset(prob012_fh_yes, select=1:2)), nrow = length(fh_yes), ncol = length(prob012_fh_yes[,1]), byrow = T ) )
  }
  snps
  
}
## helper function for handling missing data
handle_missing_data <- function(use.c.code, apply.age.start, apply.age.interval.length, Z_new, miss, present, ncuts, final_risks,
                                ref_pop, pop.weights, lambda_0, beta_est, model.competing.incidence.rates, lps){
  
  ref_full_LP <- t(ref_pop)%*%beta_est
  ###### Handle Missing Data  ##### If All times are the same
  if( length(unique(apply.age.start[miss]))==1 & length(unique(apply.age.interval.length[miss]))==1){
    
    pop.apply.age.start = unique(apply.age.start)  # change to single values so don't have to worry about dimension of ref_pop
    pop.apply.age.interval.length = unique(apply.age.interval.length)
    
    ###### Compute A_j_pop for ref_risks
    
    ref_risks   <- comp_Aj(ref_pop, pop.apply.age.start, pop.apply.age.interval.length, lambda_0, beta_est, model.competing.incidence.rates)
    
    if (use.c.code) {
      temp <- call_c1(final_risks, lps, ref_full_LP, miss, ref_risks, ref_pop, beta_est[, 1],
                      Z_new, pop.weights, ncuts=ncuts, debug = 0)
      final_risks <- temp$final ## will be: final_risks  <- temp[[1]]
      lps         <- temp$lps      ## will be: lps <- temp[[2]]
    } else {
      BETA  <- t(beta_est)
      Z_NEW <- Z_new
      REF   <- ref_pop
      PROBS <- seq(0, 1, 1/ncuts)
      
      for(i in 1:length(miss)){
        missi <- miss[i]
        
        ## make sure LPs based on non-missing covariates for the observation with missing
        present     <- which(is.na(Z_NEW[, missi])!=TRUE)
        if(length(present)==0){
          final_risks[missi] <- 0 
        }else{
          BETAV       <- BETA[1, present, drop = FALSE]
          ref_LP      <- BETAV%*%REF[present, , drop = FALSE] #just LP from predictors?
          miss_LP     <- BETAV%*%Z_NEW[present, missi, drop = FALSE] #just LP from predictors?
          
          cutpoints           <- get_cutpoints(ref_LP, PROBS)
          ncuts               <- length(cutpoints)
          miss_perc           <- get_miss_perc(cutpoints, miss_LP)
          these               <- (ref_LP >= cutpoints[miss_perc]) & (ref_LP < cutpoints[miss_perc+1])
          these[is.na(these)] <- FALSE
          if (!sum(these)) {
            temp                <- get_newEndpoints(cutpoints, miss_LP, miss_perc, ref_LP)
            these               <- (ref_LP >= temp[1]) & (ref_LP < temp[2])
            these[is.na(these)] <- FALSE
          }
          final_risks[missi]  <- weighted.mean(ref_risks[these], w = pop.weights[these], na.rm = TRUE)
          lps[missi]          <- weighted.mean(ref_full_LP[these], w = pop.weights[these], na.rm = TRUE)
        }
      }
    }
  } # END: if( length(unique(apply.age.start[miss]))==1 & length(unique(apply.age.interval.length[miss]))==1)
  
  
  ###### Handle Missing Data  ##### If All times are different
  if( length(unique(apply.age.start[miss])) > 1 || length(unique(apply.age.interval.length[miss])) > 1){
    if (use.c.code) {
      popSubFromLP = rep(0, ncol(ref_pop))
      temp  <- call_c2(final_risks, lps, ref_full_LP, miss, ref_pop, beta_est[, 1], Z_new, apply.age.start,
                       apply.age.interval.length, popSubFromLP, lambda_0, model.competing.incidence.rates, pop.weights,
                       ncuts = ncuts, debug = 0)
      final_risks <- temp$final ## will be: final_risks  <- temp[[1]]
      lps         <- temp$lps      ## will be: lps <- temp[[2]]
    } else {
      
      BETA  <- t(beta_est)
      Z_NEW <- Z_new
      REF   <- ref_pop
      CVEC  <- 2:(ncuts-1)
      PROBS <- seq(0, 1, 1/ncuts)
      
      for(i in 1:length(miss)){
        missi <- miss[i]
        
        pop.apply.age.start = apply.age.start[missi]  # change to single values so don't have to worry about dimension of ref_pop
        pop.apply.age.interval.length = apply.age.interval.length[missi];
        
        ## make sure LPs based on non-missing covariates for the observation with missing
        present = which(is.na(Z_new[,missi])!=TRUE)
        if(length(present)==0){
          final_risks[missi] <- 0 
        }else{
          BETAV       <- BETA[1, present, drop = FALSE]
          ref_LP      <- BETAV%*%REF[present, , drop = FALSE] #just LP from predictors?
          miss_LP     <- BETAV%*%Z_NEW[present, missi, drop = FALSE] #just LP from predictors?
          
          cutpoints           <- get_cutpoints(ref_LP, PROBS)
          ncuts               <- length(cutpoints)
          miss_perc           <- get_miss_perc(cutpoints, miss_LP)
          these               <- (ref_LP >= cutpoints[miss_perc]) & (ref_LP < cutpoints[miss_perc+1])
          these[is.na(these)] <- FALSE
          if (!sum(these)) {
            temp                <- get_newEndpoints(cutpoints, miss_LP, miss_perc, ref_LP)
            these               <- (ref_LP >= temp[1]) & (ref_LP < temp[2])
            these[is.na(these)] <- FALSE
          }
          temp                <- REF[,these, drop = FALSE]
          ref_risks           <- comp_Aj(temp, pop.apply.age.start, pop.apply.age.interval.length,
                                         lambda_0, beta_est, model.competing.incidence.rates)
          final_risks[missi]  <- weighted.mean(ref_risks, w = pop.weights[these], na.rm = TRUE)
          lps[missi]          <- weighted.mean(ref_full_LP[these], w = pop.weights[these], na.rm = TRUE)
        }}
    }
  }
  ## end function
  res = list(); res[[1]] = final_risks; res[[2]] = lps; res
}

# Function to compute cutpoints
get_cutpoints <- function(ref_LP, probs) {
  
  # Get the number of digits
  se     <- sd(ref_LP, na.rm = TRUE)
  if (se < 1e-15) se <- 1e-12
  prec   <- 1/(0.001*se)
  digits <- sum(prec >= 10^(1:16))
  cuts   <- quantile(ref_LP, probs = probs, names = FALSE)
  cuts   <- round(cuts, digits = digits)
  cuts   <- unique(cuts)
  if (length(cuts) < 2) stop("ERROR: computing cutpoints")
  
  cuts
  
} # END: get_cutpoints

get_endpoints <- function(cutpoints, miss_LP) {
  
  ncuts     <- length(cutpoints)
  miss_perc <- sum(cutpoints <= as.numeric(miss_LP))
  if (miss_perc == ncuts) {
    miss_perc <- miss_perc - 1
  } else if (!miss_perc) {
    miss_perc <- 1
  }
  a <- cutpoints[miss_perc]
  b <- cutpoints[miss_perc+1]
  
  c(a, b)
  
} # END: get_endpoints

# Function to return missing percentile
get_miss_perc <- function(cutpoints, miss_LP) {
  
  ncuts     <- length(cutpoints)
  miss_perc <- sum(cutpoints <= as.numeric(miss_LP))
  if (miss_perc == ncuts) {
    miss_perc <- miss_perc - 1
  } else if (!miss_perc) {
    miss_perc <- 1
  }
  
  miss_perc
  
} # END: get_miss_perc

# Functon to return the endpoints
get_newEndpoints <- function(cutpoints, miss_LP, miss_perc, ref_LP) {
  
  # Remove cutpoint defined by miss_perc + 1
  ncuts <- length(cutpoints)
  left  <- miss_perc - 1
  right <- miss_perc + 2
  for (i in 1:ncuts) {
    if (left < 1) left <- 1
    if (right > ncuts) right <- ncuts
    cut1 <- cutpoints[left]
    cut2 <- cutpoints[right]
    temp <- (ref_LP >= cut1) & (ref_LP < cut2)
    temp[is.na(temp)] <- FALSE
    if (any(temp)) break
    left  <- left - 1
    right <- right + 1
  }
  
  c(cut1, cut2)
  
} # END: get_newEndpoints

decide_if_SNP_only <- function(apply.cov.profile , model.formula, model.log.RR, model.ref.dataset, model.cov.info,
                               model.snp.info, apply.snp.profile, apply.age.start, apply.age.interval.length){
  
  if(is.null(apply.cov.profile ) & is.null(model.formula) & is.null(model.log.RR) & is.null(model.ref.dataset) & is.null(model.cov.info)){
    covs_in_model = 0
    if( is.null(model.snp.info) ){
      return_and_print("ERROR: You are fitting a SNP-only Model, and thus must provide the 'model.snp.info' object.")
      stop()
    }
    if(is.null(apply.snp.profile)){
      if(length(apply.age.start)==1 & length(apply.age.interval.length)==1){
        apply.snp.profile = matrix(ncol = nrow(model.snp.info), nrow = 10000, NA)
        print("Note: You did not provide apply.snp.profile.  Will impute SNPs for 10000 people. If require more, please provide apply.snp.profile input.")
      }else{
        apply.snp.profile = matrix(ncol = nrow(model.snp.info), nrow = length(apply.age.start), NA)
        print(paste("Note: You did not provide apply.snp.profile.  Imputed SNPs for ", length(apply.age.start) , " individuals, matching number of age intervals specified.", sep=""))
      }
    }
    if(is.vector(apply.snp.profile)){
      apply.snp.profile = cbind(apply.snp.profile)
    }
  }else{
    
    if( is.null(apply.cov.profile ) + is.null(model.formula) + is.null(model.log.RR) + is.null(model.ref.dataset) + is.null(model.cov.info) >0  ){
      return_and_print("ERROR: If any of apply.cov.profile , model.formula, model.log.RR, model.ref.dataset, or model.cov.info are NULL then they must all be NULL, and will define a SNP-only Model.")
      stop()
    }
    if(is.vector(apply.snp.profile)){
      apply.snp.profile = cbind(apply.snp.profile)
    }
    covs_in_model = 1
  }
  res <- list(); res[[1]] = covs_in_model; res[[2]] = apply.snp.profile; res
}

check_SNP_info <- function(model.snp.info){
  if( !is.data.frame(model.snp.info) && !is.matrix(model.snp.info) ){
    return_and_print("ERROR: If specified model.snp.info must be a dataframe (that contains the information on snp names, odds ratios, and allele frequencies. ")
    stop()
  }
  if( ncol(model.snp.info)!=3 ){
    return_and_print("ERROR: If specified, model.snp.info must be a dataframe with 3 columns named 'snp.name', 'snp.odds.ratio', and 'snp.freq'.")
    stop()
  }
  if( prod(is.element( names(model.snp.info), c("snp.name","snp.odds.ratio","snp.freq" )))!=1 ){
    return_and_print("ERROR: If specified, model.snp.info must be a dataframe with 3 columns named 'snp.name', 'snp.odds.ratio', and 'snp.freq'.")
    stop()
  }
}

process_SNP_info <- function(covs_in_model, apply.snp.profile, model.bin.fh.name, apply.cov.profile , model.ref.dataset, model.snp.info){
  if( covs_in_model){
    
    if(is.null(apply.snp.profile)){
      apply.snp.profile = matrix(ncol = nrow(model.snp.info), nrow = nrow(apply.cov.profile ), NA)
      print("Note: You included snp_info, but did not provide apply.snp.profile.  Will impute all SNPs. ")
    }
    if(nrow(apply.snp.profile)!=nrow(apply.cov.profile )){
      return_and_print("ERROR: apply.cov.profile  and apply.snp.profile must have same number of rows. ")
      stop()
    }
    if(!is.na(model.bin.fh.name)){
      if( !is.element( model.bin.fh.name, colnames(apply.cov.profile )) ){
        return_and_print("ERROR: model.bin.fh.name must contain the variable name of family history (matching a column name in apply.cov.profile ) if it is in the model, otherwise NA.")
        stop()
      }else{
        fh.pop = model.ref.dataset[,model.bin.fh.name]
        fh.cov = apply.cov.profile [,model.bin.fh.name]
        attenuate.fh = 1
        if( prod(is.element(fh.pop, c(0,1,"0", "1", NA)) ) == 0){
          return_and_print("ERROR: The family history must be binary when using snp_info functionality. Check input for model.ref.dataset.")
          stop()
        }
        if( prod(is.element(fh.cov, c(0,1,"0", "1", NA)) ) == 0){
          return_and_print("ERROR: The family history must be binary when using snp_info functionality. Check input for apply.cov.profile .")
          stop()
        }}
    }else{ # model.bin.fh.name = NA - family history not in the model
      fh.pop = rep(0, nrow( model.ref.dataset))
      fh.cov = rep(0, nrow( apply.cov.profile ))
      attenuate.fh = 0
      print("Note: As specified, the model does not adjust SNP imputations for family history, as model.bin.fh.name = NA.")
    }
  }else{
    fh.pop = rep(0, 10000)
    fh.cov = rep(0, nrow( apply.snp.profile))
    attenuate.fh = 0
    print("Note: As specified, the model does not adjust SNP imputations for family history.")
  }
  res <- list(); res[[1]] = attenuate.fh; res[[2]] = fh.pop; res[[3]] = fh.cov; res[[4]] = apply.snp.profile; res
}

check_disease_rates <- function(filename){
  
  lambda = read.table(filename, sep=",")
  lambda = check_flexible_rate_inputs(lambda, "model.disease.incidence.rates")
  lambda
}

check_competing_rates <- function(filename, lambda){
  
  if(is.null(filename) || filename==""){
    model.competing.incidence.rates= data.frame( cbind(lambda[,1], rep(0, length(lambda[,1]))) )
  }else{
    model.competing.incidence.rates = read.table(filename, sep=",")
  }
  model.competing.incidence.rates = check_flexible_rate_inputs(model.competing.incidence.rates, "model.competing.incidence.rates")
  model.competing.incidence.rates
}

## function to convert (start, end, rate) matrix into (integer_ages, rate) matrix
format_flexible_rate_inputs<-function(mat){
  
  if(ncol(mat)==3){
    start <- mat[,1]
    end   <- mat[,2]
    rate  <- mat[,3]
    
    integer_ages <- seq(min(start), max(end))
    formatted    <- cbind( integer_ages, rep(NA, length(integer_ages))  )
    for(i in 1:nrow(mat)){
      these              <- which(formatted[,1]>=start[i] & formatted[,1]<=end[i])
      formatted[these,2] <- rate[i]/length(these)
    }
    colnames(formatted) <- c("ages", "rates")
    formatted
  }else{
    formatted = mat
  }
  formatted
}

check_flexible_rate_inputs<-function(mat, name){
  if(!is.data.frame(mat) && !is.matrix(mat)){
    return_and_print(paste("ERROR: ", name, " must be provided as a matrix.", sep=""))
    stop()
  }
  if(ncol(mat)!=3 & ncol(mat)!=2){
    return_and_print(paste("ERROR: ", name, " must have either 2 columns: [Ages,Rates] or 3 columns:[Start_Ages, End_Ages, Rates].", sep=""))
    stop()
  }
  ll = nrow(mat)
  if(ll>1 & ncol(mat)==3){
    if(sum(mat[2:ll,1] - mat[1:(ll-1),2]-1)!=0){
      return_and_print(paste("ERROR: The rates provided in ", name, " must cover sequential age intervals (i.e. if an interval ends at age 30, the next interval must start at age 31).", sep=""))
      stop()
    }
  }
  if(ncol(mat)==2 && sum(mat[,1]%%1)!=0){
    return_and_print(paste("ERROR: The first column of ", name, " should be integer ages.", sep=""))
    stop()
  }
  if(sum(mat[,ncol(mat)]<0, na.rm=T) + sum(mat[,ncol(mat)]>1, na.rm=T)!=0){
    return_and_print("ERROR: The rates should be probabilities between 0 and 1.")
    stop()
  }
  format_flexible_rate_inputs(mat)
}

check_rates <- function(model.competing.incidence.rates, lambda, apply.age.start, apply.age.interval.length){
  
  lambda = check_flexible_rate_inputs(lambda, "model.disease.incidence.rates")
  
  if(is.null(model.competing.incidence.rates)){  model.competing.incidence.rates= cbind(lambda[,1], rep(0, length(lambda[,1])))   }
  
  model.competing.incidence.rates = check_flexible_rate_inputs(model.competing.incidence.rates, "model.competing.incidence.rates")
  
  if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start + apply.age.interval.length)[2]), lambda[,1])) == 0){
    return_and_print("ERROR: The 'model.disease.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start + apply.age.interval.length)[2]), model.competing.incidence.rates[,1])) == 0){
    return_and_print("ERROR: The 'model.competing.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  res=list(); res[[1]] = lambda; res[[2]] = model.competing.incidence.rates; res
}

check_model_inputs <- function(apply.cov.profile , model.log.RR, model.ref.dataset, model.ref.dataset.weights, model.cov.info, model.formula, n.imp){
  if(length(n.imp)!=1){
    return_and_print("ERROR: n.imp must be a single integer.")
    stop()
  }
  if( (n.imp < 1) || (n.imp > 20) ){
    return_and_print("ERROR: n.imp must be a single integer between 0 and 20.")
    stop()
  }
  if(!is.data.frame(apply.cov.profile ) && !is.matrix(apply.cov.profile )){
    return_and_print("ERROR: apply.cov.profile  must be a dataframe.")
    stop()
  }
  if(!is.data.frame(model.ref.dataset)&& !is.matrix(model.ref.dataset)){
    return_and_print("ERROR: model.ref.dataset must be a dataframe (with appropriate column names).")
    stop()
  }
  if(sum(rowSums(is.na(model.ref.dataset)))>0){
    return_and_print("ERROR: model.ref.dataset cannot contain NAs.")
    stop()
  }
  check_triple_check(model.cov.info)
  model.cov.info = process_triple_check(model.cov.info)
  
  ### Will verify all names and proper order of things against model.cov.info - so check against model first
  if(is.null(colnames(model.cov.info))){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  if(length(colnames(model.cov.info))!=length(all.vars(model.formula)[2:length(all.vars(model.formula))])){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  if( sum(colnames(model.cov.info)!=all.vars(model.formula)[2:length(all.vars(model.formula))])>0 ){
    return_and_print("ERROR: model.cov.info must have same names and order as predictors in model.formula.")
    stop()
  }
  if(prod(colnames(model.cov.info)==colnames(apply.cov.profile ))!=1){
    return_and_print("ERROR: Variable names of model.cov.info should match column names of apply.cov.profile .")
    stop()
  }
  for(k in 1:ncol(model.cov.info)){
    if(is.factor(model.cov.info[,k])){
      if(sum(is.element(apply.cov.profile [,k], model.cov.info[,k])+(is.na(c(apply.cov.profile [,k])))==0)>0){
        return_and_print(paste("ERROR: apply.cov.profile  categorical Variable (", colnames(model.cov.info)[k] ,") has levels outside levels modeled."))
        stop()
      }
    }
  }
  if(prod(colnames(model.cov.info)==colnames(model.ref.dataset))!=1){
    return_and_print("ERROR: Variable names of model.cov.info should match column names of model.ref.dataset.")
    stop()
  }
  if(nrow(model.ref.dataset) < 200){
    print(paste("WARNING: Samples in referent distribution model.ref.dataset should be large.  Currently only size ", nrow(model.ref.dataset),".", sep=""))
  }
  if(is.null(model.ref.dataset.weights)){
    model.ref.dataset.weights = rep(1/nrow(model.ref.dataset), nrow(model.ref.dataset))
  }else{
    if(length(model.ref.dataset.weights)!=nrow(model.ref.dataset)){
      return_and_print("ERROR: If model.ref.dataset.weights is provided it must be same length as the number of rows in model.ref.dataset.")
      stop()
    }
    if( sum((model.ref.dataset.weights<0), na.rm=T)!=0){
      return_and_print("ERROR: model.ref.dataset.weights must not contain negative values.")
      stop()
    }
    model.ref.dataset.weights = model.ref.dataset.weights / sum(model.ref.dataset.weights, na.rm=T)
  }
  ## for now don't allow NA's here
  for(k in 1:ncol(model.cov.info)){
    if(is.factor(model.cov.info[,k])){
      if(sum(is.element(c(model.ref.dataset[,k]), model.cov.info[,k])==0)>0){
        return_and_print(paste("ERROR: model.ref.dataset categorical Variable (", colnames(model.cov.info)[k] ,") has levels outside levels modeled."))
        stop()
      }
    }
  }
  variables <- unique(all.vars(model.formula))[-1]
  data_use  <- subset(model.cov.info, select = variables)
  
  if(is.vector(model.log.RR)==FALSE & is.matrix(model.log.RR)==FALSE){
    return_and_print("ERROR: model.log.RR must be either a vector, or a matrix with only one column.")
    stop()
  }
  if(is.matrix(model.log.RR)==TRUE){
    if(dim(model.log.RR)[2]>1){
      return_and_print("ERROR: model.log.RR must be either a vector, or a matrix with only one column.")
      stop()
    }
  }
  if(is.vector(model.log.RR)==TRUE){
    temp = names(model.log.RR)
    model.log.RR = cbind(model.log.RR)
    rownames(model.log.RR) = temp
  }
  res = list(); res[[1]] = data_use; res[[2]] = model.log.RR; res[[3]] = model.ref.dataset.weights; res
}

check_design_matrix <- function(model.log.RR, design_covs){
  
  if(is.null(rownames(model.log.RR)) ){
    return_and_print("ERROR: row names of model.log.RR must match names and order in design matrix.")
    print(paste("Row names of model.log.RR = NULL"))
    print(paste("Names of design_matrix = ", paste0(colnames(design_covs), collapse=", ") ))
    stop()
  }
  if( sum( rownames(model.log.RR)!= colnames(design_covs) )>0){
    return_and_print("ERROR: row names of model.log.RR must match names and order in design matrix.")
    print(cbind(names(model.log.RR), colnames(design_covs)))
    stop()
  }
}

check_age_inputs <- function(apply.age.start, apply.age.interval.length, apply.cov.profile, apply.snp.profile, lambda, model.competing.incidence.rates){
  
  if(!is.null(apply.cov.profile)){
    temp <- check_age_lengths(apply.age.start, apply.age.interval.length, apply.cov.profile , "apply.cov.profile ")
  }else if(!is.null(apply.snp.profile)){
    temp <- check_age_lengths(apply.age.start, apply.age.interval.length, apply.snp.profile, "apply.snp.profile")
  }else{
    return_and_print("ERROR: Must provide either apply.cov.profile or apply.snp.profile, consistent with model.")
    stop()
  }
  
  if(mode(temp)=="character"){
    return_and_print(temp)
    stop()
  }else{
    apply.age.start           <- temp[[1]]
    apply.age.interval.length <- temp[[2]]
    
    if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start + apply.age.interval.length)[2]), lambda[,1])) == 0){
      return_and_print("ERROR: The prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length' are not covered by the provided 'model.disease.incidence.rates' input. You must make these inputs consistent with one another to proceed.")
      stop()
    }
    if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start + apply.age.interval.length)[2]), model.competing.incidence.rates[,1])) == 0){
      return_and_print("ERROR: The prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length' are not covered by the provided 'model.competing.incidence.rates' input. You must make these inputs consistent with one another to proceed.")
      stop()
    }}
  NULL
}

check_age_lengths <- function(apply.age.start, apply.age.interval.length, match, match_name){
  
  if(length(apply.age.start)==1){
    apply.age.start = rep(apply.age.start, nrow(match))
  }
  if(length(apply.age.interval.length)==1){
    apply.age.interval.length = rep(apply.age.interval.length, nrow(match))
  }
  if(length(apply.age.start)!=length(apply.age.interval.length)){
    return_and_print("ERROR: apply.age.start and apply.age.interval.length must have the same length.")
    stop()
  }
  if(length(apply.age.start) != nrow(match)){
    return_and_print(paste("ERROR: apply.age.start and number of rows of ", match_name," must match.", sep=""))
    stop()
  }
  if(sum(is.na(apply.age.start)+is.na(apply.age.interval.length))>0){
    return_and_print("ERROR: apply.age.start and apply.age.interval.length may not contain missing values.")
    stop()
  }
  if(sum((apply.age.start<0)+(apply.age.interval.length<0))>0){
    return_and_print("ERROR: apply.age.start and apply.age.interval.length must contain positive values.")
    stop()
  }
  res <- list(); res[[1]] = apply.age.start; res[[2]] = apply.age.interval.length; res
}

package_results <- function(final_risks, Z_new, covs_in_model, handle.snps, apply.age.start, apply.age.interval.length, apply.cov.profile ,
                            model.log.RR, beta_est, apply.snp.profile, snps.names, return.lp, lps ){
  result <-list()
  result$risk           <- cbind(as.vector(final_risks))
  colnames(result$risk) <- c("Risk_Estimate")
  
  if(covs_in_model){
    if(handle.snps==0){
      info = cbind(as.vector(apply.age.start), as.vector(apply.age.start + apply.age.interval.length), apply.cov.profile , as.vector(final_risks))
      colnames(info) = c("Int_Start", "Int_End", colnames(apply.cov.profile ), "Risk_Estimate")
      beta.names = rownames(model.log.RR)
    }else{
      info = cbind(as.vector(apply.age.start), as.vector(apply.age.start + apply.age.interval.length), cbind( apply.snp.profile, apply.cov.profile ), as.vector(final_risks))
      colnames(info) = c("Int_Start", "Int_End", snps.names, colnames(apply.cov.profile ), "Risk_Estimate")
      beta.names = c( snps.names, rownames(model.log.RR) )
    }
  }else{
    info = cbind(as.vector(apply.age.start), as.vector(apply.age.start + apply.age.interval.length), apply.snp.profile, as.vector(final_risks))
    colnames(info) = c("Int_Start", "Int_End", snps.names, "Risk_Estimate")
    beta.names =  snps.names
  }
  result$details = info
  beta.used = beta_est
  rownames(beta.used) <- beta.names
  colnames(beta.used) <- "log OR used"
  result$beta.used    <- beta.used
  
  if(return.lp==T){
    result$lps <- lps
  }
  result
}

#' Building and Applying an Absolute Risk Model
#'
#' This function is used to build absolute risk models and apply them to estimate absolute risks.
#'
#' @param ref.pop design matrix created from dataframe of risk factors for a sample of subjects representative of underlying population, no missing values.
#' @param apply.age.start single integer or vector of integer ages for the start of the interval over which to compute absolute risk.
#' @param apply.age.interval.length single integer or vector of integer years over which absolute risk should be computed.
#' @param lambda_0 two column matrix [ integer ages, incidence rates] with incidence rate of disease. Must fully cover age interval for estimation.
#' @param beta_est vector with log odds ratios corresponding to the model params; no intercept; names must match design matrix, \code{ref_pop}.
#' @param model.competing.incidence.rates two column matrix [ integer ages, incidence rates] with incidence rate of competing events. Must fully cover age interval for estimation.
#' @param handle.snps binary indicator of whether SNPs are in the design matrix or not.  If so, design matrix has been stacked 5 times.
#' @return This function returns risks for the referent risk factor dataset.
#' @export
#' @examples
#' print("Hello world")
get_refs_risk <- function(ref_pop, apply.age.start, apply.age.interval.length, lambda_0, beta_est, model.competing.incidence.rates, handle.snps, n.imp ){
  
  refs.risk = comp_Aj(ref_pop, apply.age.start[1], apply.age.interval.length[1], lambda_0, beta_est, model.competing.incidence.rates)
  refs.lps = t(ref_pop)%*%beta_est
  
  if(handle.snps){
    refs.risk = rowMeans( matrix(refs.risk, ncol=n.imp, nrow=length(refs.risk)/n.imp, byrow=F))
    refs.lps  = rowMeans( matrix(refs.lps,  ncol=n.imp, nrow=length(refs.lps)/n.imp, byrow=F))
  }
  res = list(); res[[1]] = refs.risk; res[[2]] = refs.lps ; res
}

#' Risk Stratification from Polygenic Risk Score (PRS) based on Variance Explained
#'
#' This function is used to build absolute risk models and apply them to estimate absolute risks.
#'
#' @param apply.age.start single integer or vector of integer ages for the start of the interval over which to compute absolute risk.
#' @param apply.age.interval.length single integer or vector of integer years over which absolute risk should be computed.
#' @param model.disease.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of disease. Must fully cover age interval for estimation.
#' @param use.c.code binary indicator of whether to run the c program for fast computation.
#' @param model.competing.incidence.rates two column matrix [ integer ages, incidence rates] or three column matrix [start age, end age, rate] with incidence rate of competing events. Must fully cover age interval for estimation.
#' @param variance.explained proportion of variance explained by PRS
#' @param N number of simulated PRS values
#' @param predict.stand.vals standardized values for which to make a risk prediction
#' @return This function returns risks based on simulated PRS based on SNPs with given \code{variance.explained}.
#' @export
#' @examples
#' print("Hello world")
PRS.research <- function(apply.age.start, apply.age.interval.length, model.disease.incidence.rates, use.c.code = 1,
                         model.competing.incidence.rates = NULL, variance.explained, N = 10000,
                         predict.stand.vals = NULL){
  
  if(length(apply.age.start)!=1 || length(apply.age.interval.length)!=1){
    return_and_print("ERROR:  You may only choose one value for apply.age.start and one value for apply.age.interval.length.")
    stop()
  }
  apply.age.start      <- rep(apply.age.start, N)
  apply.age.interval.length <- rep(apply.age.interval.length, N)
  lambda       <- model.disease.incidence.rates
  if(is.null(model.competing.incidence.rates)){  model.competing.incidence.rates= cbind(lambda[,1], rep(0, length(lambda[,1])))   }
  
  if(ncol(lambda)!=2){ return_and_print("ERROR: model.disease.incidence.rates should have 2 columns: [Ages,Rates]"); stop() }
  
  if(ncol(model.competing.incidence.rates)!=2){ return_and_print("ERROR: model.competing.incidence.rates should have 2 columns: [Ages,Rates]"); stop() }
  
  if(sum(lambda[,1]%%1)!=0){ return_and_print("ERROR: The first column of model.disease.incidence.rates should be integer ages."); stop()  }
  
  if(sum(model.competing.incidence.rates[,1]%%1)!=0){ return_and_print("ERROR: The first column of model.competing.incidence.rates should be integer ages."); stop()  }
  if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start+apply.age.interval.length)[2]), lambda[,1])) == 0){
    return_and_print("ERROR: The 'model.disease.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  if( prod(is.element(seq(range(apply.age.start)[1], range(apply.age.start+apply.age.interval.length)[2]), model.competing.incidence.rates[,1])) == 0){
    return_and_print("ERROR: The 'model.competing.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'apply.age.start' and 'apply.age.interval.length.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  
  PRS.         <- rnorm(N)
  log.OR       <- variance.explained^0.5
  pop.dist.mat <- cbind(PRS.)
  beta_est     <- as.matrix(nrow = length(c( log.OR)), ncol = 1, c( log.OR) )
  Z_new        <- t(pop.dist.mat)
  pop.weights  <- rep(1/nrow(pop.dist.mat), length(pop.dist.mat))
  
  approx_expectation_rr = weighted.mean(  exp( pop.dist.mat%*% beta_est), w = pop.weights ) ## all equal weights
  calc = precise_lambda0(lambda, approx_expectation_rr, beta_est, pop.dist.mat, pop.weights)
  lambda_0 = calc[[1]]
  precise_expectation_rr = calc[[2]]
  pop.dist.mat = t(pop.dist.mat )
  
  ###### Compute A_j  ##
  final_risks <- comp_Aj(Z_new, apply.age.start, apply.age.interval.length, lambda_0, beta_est, model.competing.incidence.rates)
  
  if(is.null(predict.stand.vals)==0){
    
    if(is.vector(predict.stand.vals)==0){
      return_and_print("ERROR: predict.stand.vals must be a vector")
      stop()
    }else{
      temp = t(cbind(predict.stand.vals))
      specific_risks <- comp_Aj(temp, apply.age.start[1:length(predict.stand.vals)], apply.age.interval.length[1:length(predict.stand.vals)], lambda_0, beta_est, model.competing.incidence.rates)
    }
  }
  results      <- list()
  results$risk <- final_risks
  if(is.null(predict.stand.vals)==0){
    results$predictions.for.stand.vals <- specific_risks
  }
  results
}

return_and_print <- function(x){
  print(x)
  return(x)  
}

