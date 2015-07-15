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

## triple.check must be a list with the proper formats
# 
# age.new=age_new
# age.interval=tau
# cov.new = cov_new
# beta.given = beta_given
# population.incidence.rates = bc_incidence_rates
# dist.risk.factors = risk_factor_distribution  
# competing.incidence.rates=mortality_rates
# return.lp=F; modify.variables=NULL
# triple.check=triple_check
# snp.info = snp_info
# genotype.new = genotype_new
# use.c.code=1
# return.refs.risk = F

# #cov.new[2,2]=NA; cov.new[4,4]=NA
# cov.new<-data.frame(  cov.new[1:4,] )

# age.new<-rep(30,4)
# age.interval<-rep(40,4)
# age.new[2]=32
# age.new[4]=34

compute.absolute.risk <- function(age.new, age.interval, cov.new = NULL, model.predictor = NULL, 
                                  population.incidence.rates, beta.given = NULL, dist.risk.factors = NULL, dist.weights = NULL,
                                  triple.check = NULL, use.c.code, competing.incidence.rates = NULL, return.lp = F, 
                                  genotype.new = NULL, snp.info = NULL, return.refs.risk = F, bin.fh.name = NA, n.imp = 5 ){
  set.seed(3948792)
  decision      <- decide_if_SNP_only(cov.new, model.predictor, beta.given, dist.risk.factors, triple.check, snp.info, genotype.new)
  covs_in_model <-  decision[[1]]
  if(length(decision)>1) genotype.new   <-  decision[[2]]
  
  handle.snps = 1 - is.null(snp.info)
  
  if (covs_in_model) {
    
    temp         <- check_age_lengths(age.new, age.interval, cov.new, "cov.new")
    age.new      <- temp[[1]]
    age.interval <- temp[[2]]
    
    temp         <- check_model_inputs(cov.new, beta.given, dist.risk.factors, dist.weights, triple.check, model.predictor, n.imp)
    data_use     <- temp[[1]]
    beta.given   <- temp[[2]]
    dist.weights <- temp[[3]]
    
    design_covs <- make_design_matrix_covs(data_use, cov.new, model.predictor)
    
    check_design_matrix(beta.given, design_covs)
    Z_new        <- t(design_covs); rm(design_covs); gc()
    beta_est     <- as.matrix(nrow = length(beta.given), ncol=1, beta.given)
    pop.dist.mat <- make_design_matrix_dist(data_use, dist.risk.factors, model.predictor)
    pop.weights  <- dist.weights
  }
    
  if(handle.snps){
    
    check_SNP_info(snp.info)

    snps.names <- snp.info[,"snp.name"]
    snps.betas <- log( snp.info[,"snp.odds.ratio"] )
    snps.freqs <- snp.info[,"snp.freq"]
  
    processed_info = process_SNP_info(covs_in_model, genotype.new, bin.fh.name, cov.new, dist.risk.factors, snp.info)

    attenuate.fh  <-  processed_info[[1]]   
    fh.pop        <-  processed_info[[2]]    
    fh.cov        <-  processed_info[[3]]
    genotype.new  <-  processed_info[[4]] 
  }

  if (covs_in_model) {
    
    if(handle.snps){
      # covariate_stack5 <- rbind(pop.dist.mat, pop.dist.mat, pop.dist.mat, pop.dist.mat, pop.dist.mat)
      covariate_stack5 <- do.call("rbind", replicate(n.imp, pop.dist.mat, simplify = FALSE))
      simulated_snps   <- sim_snps(snps.betas, snps.freqs, cbind( rep( fh.pop, n.imp)) )
      pop.dist.mat     <- cbind( simulated_snps, covariate_stack5 )
      pop.weights      <- rep( dist.weights, n.imp )
      
      if(attenuate.fh){
        var_prs <- sum((snps.betas^2)*2*snps.freqs*(1-snps.freqs))
        alpha   <- var_prs/2
        if(triple.check[[which(bin.fh.name==colnames(cov.new))]]$type=="factor"){
          bin.fh.name = paste("as.factor(", bin.fh.name, ")1", sep="")
        }
        beta_est[bin.fh.name,1] <- beta_est[bin.fh.name,1] - alpha
      }
      beta_est <- as.matrix(nrow = length(c( snps.betas, beta_est)), ncol = 1, c( snps.betas, beta_est) )
      Z_new    <- rbind(t(genotype.new), Z_new)
    }
  } else {
    temp         <- check_age_lengths(age.new, age.interval, genotype.new, "genotype.new")
    age.new      <- temp[[1]]
    age.interval <- temp[[2]]
    
    if(handle.snps){
      pop.dist.mat <- sim_snps(snps.betas, snps.freqs, cbind( rep( fh.pop, n.imp)) )
      pop.weights  <- rep( 1/nrow(pop.dist.mat), nrow(pop.dist.mat) )
      beta_est     <- as.matrix(nrow = length(c( snps.betas)), ncol = 1, c( snps.betas) )
      Z_new        <- t(genotype.new)
    } 
  }  
  lambda                    <- population.incidence.rates; rm(population.incidence.rates)
  res                       <- check_rates(competing.incidence.rates, lambda, age.new, age.interval)
  lambda                    <- res[[1]]
  competing.incidence.rates <- res[[2]]; rm(res)
  approx_expectation_rr     <- weighted.mean(  exp( pop.dist.mat%*% beta_est), w = pop.weights, na.rm=T)
  calculation               <- precise_lambda0(lambda, approx_expectation_rr, beta_est, pop.dist.mat, pop.weights)
  lambda_0                  <- calculation[[1]]
  precise_expectation_rr    <- calculation[[2]]
  pop.dist.mat              <- t(pop.dist.mat )

  ###### Compute A_j  ## only those without NA
  final_risks <- rep(NA, ncol(Z_new))
  these = which(colSums( is.na(Z_new))==0 )
  
  if( length(these) > 0 ){
      temp               <- subset(Z_new, select=these)
      final_risks[these] <- comp_Aj(temp, age.new[these], age.interval[these], lambda_0, beta_est, competing.incidence.rates)
  }
  miss    <- which(is.na(final_risks))  
  present <- which(!is.na(final_risks))
  ref_pop <- pop.dist.mat;                    
  ncuts   <- 100
  t00     <- proc.time()

  if(!handle.snps){
      final_risks <- handle_missing_data(use.c.code, age.new, age.interval, Z_new, miss, present, ncuts, final_risks, ref_pop, pop.weights, lambda_0, beta_est, competing.incidence.rates)
  } else {
      set = rep(F, nrow(genotype.new))
      set[miss]=T
      miss_w_all_SNPs_present <- miss[ which( rowSums(is.na(subset(genotype.new, subset=set)))==0 )]
      miss_w_some_SNPs_miss   <- miss[ which( rowSums(is.na(subset(genotype.new, subset=set)))>0 ) ]
      
      if (length(miss_w_all_SNPs_present) > 0) {
        final_risks <- handle_missing_data(use.c.code, age.new, age.interval, Z_new, miss_w_all_SNPs_present, setdiff(seq(1, nrow(cov.new)), miss_w_all_SNPs_present), ncuts, final_risks, ref_pop, pop.weights, lambda_0, beta_est, competing.incidence.rates)
      }
      if (length(miss_w_some_SNPs_miss) > 0) {
        final_risks[miss_w_some_SNPs_miss] <- handle_missing_SNPs_and_covs(miss_w_some_SNPs_miss, Z_new, snps.betas, snps.freqs, age.new, age.interval, lambda_0, beta_est, competing.incidence.rates, fh.cov, ref_pop, pop.weights, use.c.code, ncuts)
      }
  }
  t11    <- proc.time() - t00;  print(t11)
  result <- package_results(final_risks, covs_in_model, handle.snps, age.new, age.interval, cov.new, beta.given, beta_est, genotype.new, snps.names, return.lp)
  if(return.refs.risk) result$refs.risk <- get_refs_risk(ref_pop, age.interval, lambda_0, beta_est, competing.incidence.rates, handle.snps )
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
get_int <- function(a,t,lambda, Z_new, beta_est, competing.incidence.rates, ZBETA = NULL){

  holder<-0
  if (is.null(ZBETA)) {
    ZBETA <- t(exp(t(Z_new)%*%beta_est))
  }

  for(u in min(a, na.rm = T):max(t, na.rm = T)){
    temp0  <- (u>=a)*(u<t)     
    holder <- holder + temp0*( (pick_lambda(u,lambda))*ZBETA + competing.incidence.rates[which(u==competing.incidence.rates[,1]),2])
  }
  holder
}

get_beta_given_names <-function(triple.check, model.predictor){
  
  check_triple_check(triple.check)
  triple.check = process_triple_check(triple.check)
  
  if(is.null(colnames(triple.check))){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  if(length(colnames(triple.check))!=length(all.vars(model.predictor)[2:length(all.vars(model.predictor))])){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  if( sum(colnames(triple.check)!=all.vars(model.predictor)[2:length(all.vars(model.predictor))])>0 ){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  variables <- unique(all.vars(model.predictor))[-1]
  data_use  <- subset(triple.check, select = variables)
  data_use[,all.vars(model.predictor)[1]] <- rep(0, nrow(data_use))
  predictors <- as.matrix(model.matrix(model.predictor, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.predictor, data = as.data.frame(data_use)))])
  colnames(predictors)
  
}

###  make design matrix for cov.new
make_design_matrix_covs <- function(data_use, cov.new, model.predictor){
  
  options(na.action='na.pass')
  init_n   <- nrow(data_use)
  jump_cov <- nrow(cov.new)
  
  data_use   <- rbind(data_use, cov.new)
  data_use[,all.vars(model.predictor)[1]] <- rep(0, nrow(data_use))

  predictors <- as.matrix(model.matrix(model.predictor, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.predictor, data = as.data.frame(data_use)))])
  set        <- rep(F, nrow(predictors))
  set[(init_n+1):(init_n+jump_cov)]=T
  cov.new    <- subset( predictors, subset = set)
  cov.new
}

###  make design matrix for dist.risk.factors
make_design_matrix_dist <- function(data_use, dist.risk.factors, model.predictor){
  
  init_n   <- nrow(data_use)
  jump_cov <- nrow(dist.risk.factors)
  
  data_use <- rbind(data_use, dist.risk.factors)
  data_use <- cbind(data_use, rep(0, nrow(data_use)))
  colnames(data_use) <- c(colnames(data_use)[1:(length(colnames(data_use))-1)],  all.vars(model.predictor)[1])
  
  predictors   <- as.matrix(model.matrix(model.predictor, data = as.data.frame(data_use))[,2:ncol(model.matrix(model.predictor, data = as.data.frame(data_use)))])
  pop.dist.mat <- predictors[(init_n+1):(init_n+jump_cov),]
  cbind(pop.dist.mat)
}                                  
 
###### Compute Absolute Risk
comp_Aj <- function(Z_new, age.new, age.interval, lambda, beta_est, competing.incidence.rates){
   
    ZBETA <- t(exp(t(beta_est)%*%Z_new))
    avec  <- age.new + age.interval 
    tvec  <- min(age.new, na.rm = T):max(avec, na.rm = T)
    temp  <- match(tvec, lambda[,1])
    c2    <- t(Z_new)%*%beta_est
    c3    <- log(lambda[temp, 2])

    Aj_est <- rep(0, ncol(Z_new))
    for(i in 1:length(tvec)){
      t         <- tvec[i]
      temp      <- get_int(age.new,t,lambda, Z_new, beta_est, competing.incidence.rates, ZBETA = ZBETA)
      this_year <- (t >= age.new)*(t < avec)*exp(c3[i] + c2 - temp)     
                                                                                                                                                            
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

## transform triple.check into a form easily usable in the function
process_triple_check <- function(triple.check){
  maximum_dim = 0  
  for(i in 1:length(triple.check)){ 
    maximum_dim = max(maximum_dim, length(triple.check[[i]]$levels) )
  }
  matt = data.frame(starter_column = rep(0, maximum_dim))
  
  for(i in 1:length(triple.check)){
    
    if(triple.check[[i]]$type == "continuous"){
        matt[,triple.check[[i]]$name] = rep(0,maximum_dim)
    }
    if(triple.check[[i]]$type == "factor"){
        matt[,triple.check[[i]]$name] = factor( c(triple.check[[i]]$levels, rep(triple.check[[i]]$levels[1], maximum_dim - length(triple.check[[i]]$levels))), levels = unique(c(triple.check[[i]]$levels, rep(triple.check[[i]]$levels[1], maximum_dim - length(triple.check[[i]]$levels)))))
        ### if there is a referent level specified, recode that way
        if(is.null(triple.check[[i]]$ref)==FALSE){
            matt[,triple.check[[i]]$name] = relevel(matt[,triple.check[[i]]$name], ref = as.character(triple.check[[i]]$ref))
        }
    }
  }
  matt[,1] <- NULL
  matt
}

## verify that triple.check is in the proper form
check_triple_check <- function(triple.check){
  
  if( is.list(triple.check)!=TRUE){
    print("WARNING: triple.check must be a list.")
    stop()
  }
  for(i in 1:length(triple.check)){
    if( is.list(triple.check[[i]])!=TRUE ){
      print("WARNING: Each element of triple.check must be a list (that contains the information for a variable). ")
      stop()
    }
    if( is.null(triple.check[[i]]$name) ){
      print("WARNING: Each list within triple.check describing a variable must have a 'name' field. ")
      stop()
    }
    if( is.null(triple.check[[i]]$type) ){
      print("WARNING: Each list within triple.check describing a variable must have a 'type' field. ")
      stop()
    }}
  for(i in 1:length(triple.check)){
    
    if( triple.check[[i]]$type == "continuous"  & is.null(triple.check[[i]]$levels)!=TRUE){
      print(paste("WARNING: You have specified that the variable '", triple.check[[i]]$name, "' is continuous, so the 'levels' input for that variable is not needed and will not be used.", sep="") )
    }# allow to continue
    if( triple.check[[i]]$type == "factor"  & is.null(triple.check[[i]]$levels)==TRUE){
      print(paste("WARNING: You must specify the 'levels' field of the variable '", triple.check[[i]]$name, "', because you gave its type to be 'factor'.", sep="") )
    }
    if( triple.check[[i]]$type == "factor"  & is.null(triple.check[[i]]$levels)==FALSE){
      if(is.vector(triple.check[[i]]$levels)!=TRUE ){
        print(paste("WARNING: You must specify the 'levels' field of the variable '", triple.check[[i]]$name, "', as a vector.", sep="") )
      }
      if(is.null(triple.check[[i]]$ref)==FALSE){
        if(is.element(triple.check[[i]]$ref, triple.check[[i]]$levels)==FALSE){
          print(paste("WARNING: The 'ref' field of the variable '", triple.check[[i]]$name, "' must specify a referent level that is contained in the 'levels' field for that variable.", sep="") )
        }
      }
    }
  }  
}
## helper function
## creates triple.check from a dataframe
## option to flag factor variables by including a vector of Variable names
## if factor_vars input is not provided, then considered continuous if more than 12 unique levels, else factor
make_triple_check <- function(frame, factor_vars = NULL){
  
  if( is.data.frame(frame)!=TRUE){
    print("WARNING: input must be a dataframe")
    stop()
  }
  
  the_names = colnames(frame)
  triple.check = list()
  length(triple.check)=length(the_names)
  
  if(is.null(factor_vars)==FALSE){
    if(is.vector(factor_vars)!=TRUE ){
      print(paste("WARNING: The optional 'flag' of factor variables must be specified as a vector.", sep="") )
      stop()
    }
    if( prod( is.element(factor_vars, the_names)) == 0 ){
      print(paste("WARNING: The optional 'flag' of factor variables must contain names that match the column names of the dataframe.", sep="") )
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
    triple.check[[i]]=temp 
  }
  triple.check
}

## Function for combining Absolute Risks for Adjacent Intervals
combine_risks_two_intervals <- function(age_start_1, age_interval_1, absolute_risks_1, age_start_2, age_interval_2, 
                                        absolute_risks_2, competing.incidence.rates = NULL){
  
  if( sum(age_start_1 + age_interval_1 != age_start_2) >0 ){
    print(paste("WARNING: To combine risks for two intervals, they must be adjacent.", sep="") )
    stop()
  }
  if(is.null(competing.incidence.rates)){ competing.incidence.rates= cbind(seq(0,100), rep(0, 101))
  }
  
  competing_AR = comp_AR_compete(age_start_1, age_interval_1, competing.incidence.rates)
  
  overall_age_start = age_start_1
  overall_age_interval = age_interval_1 + age_interval_2
  overall_absolute_risks =  absolute_risks_1 + (1-competing_AR)*(1 - absolute_risks_1)*absolute_risks_2
  
  result = list()
  result$details = cbind(overall_age_start, overall_age_interval, overall_absolute_risks)
  result$risk = cbind(overall_absolute_risks)
  result
}

## helper function for computing absolute risk of competing mortality
comp_AR_compete <- function(age.new, age.interval, competing.incidence.rates){
  ###### Compute A_j
  
  Aj_est <- 0
  for(t in min(age.new, na.rm = T):max(age.new+age.interval, na.rm = T)){
    
    this_year <- (t>=age.new)*(t<age.new+age.interval)*exp( log(pick_lambda(t, competing.incidence.rates)) - get_int_compete(age.new,t, competing.incidence.rates) )#ex[t-age.new+1]=Aj_est
    Aj_est    <- Aj_est + this_year      
  }
  Aj_est
} 

## helper function for computing survival of competing risk
get_int_compete <- function(a,t,competing.incidence.rates){
  
  holder <- 0
  for(u in min(a, na.rm = T):max(t, na.rm = T)){
    holder <- holder+(u>=a)*(u<t)*competing.incidence.rates[which(u==competing.incidence.rates[,1]),2]
  }
  holder
}

wrapper <- function(age.new, age.interval, cov.new, model.predictor, population.incidence.rates, 
                    beta.given, dist.risk.factors, triple.check, use.c.code, competing.incidence.rates = NULL, 
                    return.lp = F, genotype.new = NULL, snp.info = NULL, bin.fh.name = NULL, cut.time = NULL, cov.new.2 = NULL, 
                    model.predictor.2 = NULL, beta.given.2 = NULL, dist.risk.factors.2 = NULL, triple.check.2 = NULL, bin.fh.name.2 = NULL, n.imp = 5){

  ## if any of the second arguments are specified, then two two version
  if( is.null( cut.time )*is.null( cov.new.2 )*is.null( model.predictor.2 )*is.null( beta.given.2 )*is.null( dist.risk.factors.2 )*is.null( triple.check.2 ) ==0 ){
    
    if(is.null( cut.time )){
      print(paste("WARNING: If you wish to use different model inputs over parts of the age interval, must specify cut.time.", sep="") )
      stop()
    }
    if( sum( (cut.time < age.new) + (cut.time > age.new + age.interval) ) >0 ){
      print(paste("Note: You provided cut.times outside the interval defined by age.new and age.interval.  Will compute risk using either inputs1 or inputs2 only, depending on whether the interval is below or above the cutpoint.", sep="") )
    }
    ## for the rest, if not specified use originals
    if(is.null( cov.new.2 )){
      cov.new.2 = cov.new
    }
    if(is.null( model.predictor.2 )){
      model.predictor.2 = model.predictor
    }

    if(is.null( beta.given.2 )){
      beta.given.2 = beta.given
    }
    if(is.null( dist.risk.factors.2 )){
      dist.risk.factors.2 = dist.risk.factors
    }
    if(is.null( triple.check.2 )){
      triple.check.2 = triple.check
    }
    if(is.null( bin.fh.name.2 )){
      bin.fh.name.2 = bin.fh.name
    }
    
    age.new.1 = age.new
    age.interval.1 = (cut.time - age.new)*( (cut.time - age.new) < age.interval) +   (age.interval)*( 1 - ( (cut.time - age.new) < age.interval))
    age.interval.1[which(age.interval.1<0)]=0
    
    age.new.2 = age.new.1 + age.interval.1
    age.interval.2 = age.new + age.interval - age.new.2
    
    result1 = compute.absolute.risk(age.new.1, age.interval.1, cov.new, model.predictor, population.incidence.rates, beta.given, dist.risk.factors, triple.check, use.c.code, competing.incidence.rates, return.lp, genotype.new = genotype.new, snp.info = snp.info, bin.fh.name = bin.fh.name, n.imp = n.imp )
    result2 = compute.absolute.risk(age.new.2, age.interval.2, cov.new.2, model.predictor.2, population.incidence.rates, beta.given.2, dist.risk.factors.2, triple.check.2, use.c.code, competing.incidence.rates, return.lp, genotype.new = genotype.new, snp.info = snp.info,  bin.fh.name = bin.fh.name.2, n.imp = n.imp )

    result = combine_risks_two_intervals(result1$details[,"Int_Start"], result1$details[,"Int_End"] - result1$details[,"Int_Start"], result1$details[,"Risk_Estimate"], result2$details[,"Int_Start"], result2$details[,"Int_End"] - result2$details[,"Int_Start"], result2$details[,"Risk_Estimate"], competing.incidence.rates = competing.incidence.rates)
    result$details = cbind(age.new.1, age.new.2, age.new.2 + age.interval.2, cov.new, cov.new.2, result$risk)    
  }
  else{  # just run standard function
    result = compute.absolute.risk(age.new, age.interval, cov.new, model.predictor, population.incidence.rates, beta.given, dist.risk.factors, triple.check, use.c.code, competing.incidence.rates, return.lp, genotype.new = genotype.new, snp.info = snp.info, bin.fh.name = bin.fh.name, n.imp = n.imp)
  }
  
  result
}

call_c1 <- function(final, miss, ref_risks, refmat, betavec, zmat, pop.weights, ncuts = 100, debug = 0) {


  DMISS           <- 999999999.9
  DMISS_TEST      <- 999999999.0
  zmat            <- zmat[, miss, drop = FALSE] 
  temp            <- !is.finite(zmat)
  zmat[temp]      <- DMISS
  temp            <- !is.finite(ref_risks)
  ref_risks[temp] <- DMISS
  temp            <- !is.finite(refmat)
  refmat[temp]    <- DMISS
  n_beta          <- length(betavec)
  probs           <- seq(0, 1, 1/ncuts)
  n_probs         <- length(probs)
  nr_z            <- ncol(zmat)
  nc_z            <- nrow(zmat)
  nr_ref          <- ncol(refmat)
  nc_ref          <- nrow(refmat)
  retvec          <- rep(DMISS, length(miss))
  retflag         <- 1
  
  temp <- .C("ref_risk1", as.numeric(ref_risks), as.numeric(betavec), as.numeric(t(zmat)), 
       as.numeric(t(refmat)), as.integer(n_beta), as.integer(nr_z), as.integer(nc_z),
       as.integer(nr_ref), as.integer(nc_ref), as.numeric(probs), as.integer(n_probs),
       as.integer(debug), as.numeric(pop.weights),
       retvec = as.numeric(retvec), retflag = as.integer(retflag))

  retflag <- temp$retflag
  if (retflag) stop("ERROR in c code")
  retvec  <- temp$retvec
  temp    <- retvec > DMISS_TEST
  if (any(temp)) retvec[temp] <- NA
  final[miss] <- retvec

  final
  
} # END: call_c1

call_c2 <- function(final, miss, refmat, betavec, zmat, age_new, age_int, popSubFromLP, 
                    lambda_0, compRates0, pop.weights, ncuts = 100, debug = 0) {

  DMISS           <- 999999999.9
  DMISS_TEST      <- 999999999.0
  zmat            <- zmat[, miss, drop = FALSE] 
  temp            <- !is.finite(zmat)
  zmat[temp]      <- DMISS
  temp            <- !is.finite(refmat)
  refmat[temp]    <- DMISS
  n_beta          <- length(betavec)
  probs           <- seq(0, 1, 1/ncuts)
  n_probs         <- length(probs)
  nr_z            <- ncol(zmat)
  nc_z            <- nrow(zmat)
  nr_ref          <- ncol(refmat)
  nc_ref          <- nrow(refmat)
  retvec          <- rep(DMISS, length(miss))
  retflag         <- 1

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
            as.numeric(lambda), as.numeric(compRates), as.numeric(pop.weights),
              retvec = as.numeric(retvec), retflag = as.integer(retflag))

  retflag <- temp$retflag
  if (retflag) stop("ERROR in c code")
  retvec  <- temp$retvec
  temp    <- retvec > DMISS_TEST
  if (any(temp)) retvec[temp] <- NA
  final[miss] <- retvec

  final
  
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
handle_missing_data <- function(use.c.code, age.new, age.interval, Z_new, miss, present, ncuts, final_risks, 
                                ref_pop, pop.weights, lambda_0, beta_est, competing.incidence.rates){
  
  ###### Handle Missing Data  ##### If All times are the same
  if( length(unique(age.new[miss]))==1 & length(unique(age.interval[miss]))==1){
    
    pop.age.new = unique(age.new)  # change to single values so don't have to worry about dimension of ref_pop
    pop.age.interval = unique(age.interval)
    
    ###### Compute A_j_pop for ref_risks
    ref_risks <- comp_Aj(ref_pop, pop.age.new, pop.age.interval, lambda_0, beta_est, competing.incidence.rates)
   
    if (use.c.code) {
      final_risks <- call_c1(final_risks, miss, ref_risks, ref_pop, beta_est[, 1], 
                             Z_new, pop.weights, ncuts=ncuts, debug = 0) 
    } else {
      BETA  <- t(beta_est)
      Z_NEW <- Z_new
      REF   <- ref_pop
      PROBS <- seq(0, 1, 1/ncuts)
      
      for(i in 1:length(miss)){
        missi <- miss[i]
        
        ## make sure LPs based on non-missing covariates for the observation with missing
        present     <- which(is.na(Z_NEW[, missi])!=TRUE)
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
      }
    }
  } # END: if( length(unique(age.new[miss]))==1 & length(unique(age.interval[miss]))==1)  
  
  
  ###### Handle Missing Data  ##### If All times are different
  if( length(unique(age.new[miss])) > 1 || length(unique(age.interval[miss])) > 1){
    
    if (use.c.code) {
      popSubFromLP = rep(0, ncol(ref_pop))
      final_risks  <- call_c2(final_risks, miss, ref_pop, beta_est[, 1], Z_new, age.new, 
                               age.interval, popSubFromLP, lambda_0, competing.incidence.rates, pop.weights,
                               ncuts = ncuts, debug = 0) 
    } else {
      
      BETA  <- t(beta_est)
      Z_NEW <- Z_new
      REF   <- ref_pop
      CVEC  <- 2:(ncuts-1)
      PROBS <- seq(0, 1, 1/ncuts)
      
      for(i in 1:length(miss)){
        missi <- miss[i]
        
        pop.age.new = age.new[missi]  # change to single values so don't have to worry about dimension of ref_pop
        pop.age.interval = age.interval[missi]; 
        
        ## make sure LPs based on non-missing covariates for the observation with missing
        present = which(is.na(Z_new[,missi])!=TRUE)
        
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
        ref_risks           <- comp_Aj(temp, pop.age.new, pop.age.interval, 
                                       lambda_0, beta_est, competing.incidence.rates)
        final_risks[missi]  <- weighted.mean(ref_risks, w = pop.weights[these], na.rm = TRUE)   
      }
    }
  }
  ## end function
  final_risks
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

decide_if_SNP_only <- function(cov.new, model.predictor, beta.given, dist.risk.factors, triple.check, 
                               snp.info, genotype.new){
  
  if(is.null(cov.new) & is.null(model.predictor) & is.null(beta.given) & is.null(dist.risk.factors) & is.null(triple.check)){
    covs_in_model = 0
    if( is.null(snp.info) ){
      print("WARNING: You are fitting a SNP-only Model, and thus must provide the 'snp.info' object.")
      stop()
    }
    if(is.null(genotype.new)){
      genotype.new = matrix(ncol = nrow(snp.info), nrow = 100, NA)
      print("You did not provide genotype.new.  Will impute SNPs for 100 people. If require more, please provide genotype.new input.")
    }
    if(is.vector(genotype.new)){
      genotype.new = cbind(genotype.new)
     }
  }else{
    
    if( is.null(cov.new) + is.null(model.predictor) + is.null(beta.given) + is.null(dist.risk.factors) + is.null(triple.check) >0  ){
      print("WARNING: If any of cov.new, model.predictor, beta.given, dist.risk.factors, or triple.check are NULL then they must all be NULL, and will define a SNP-only Model.")
      stop()
    }
    if(is.vector(genotype.new)){
      genotype.new = cbind(genotype.new)
    }
    covs_in_model = 1
  }
  res <- list(); res[[1]] = covs_in_model; res[[2]] = genotype.new; res
}

check_SNP_info <- function(snp.info){
  if( is.data.frame(snp.info)!=TRUE ){
    print("WARNING: If specified snp.info must be a dataframe (that contains the information on snp names, odds ratios, and allele frequencies. ")
    stop()
  }
  if( ncol(snp.info)!=3 ){
    print("WARNING: If specified, snp.info must be a dataframe with 3 columns named 'snp.name', 'snp.odds.ratio', and 'snp.freq'.")
    stop()
  }
  if( prod(is.element( names(snp.info), c("snp.name","snp.odds.ratio","snp.freq" )))!=1 ){
    print("WARNING: If specified, snp.info must be a dataframe with 3 columns named 'snp.name', 'snp.odds.ratio', and 'snp.freq'.")
    stop()
  }
}

process_SNP_info <- function(covs_in_model, genotype.new, bin.fh.name, cov.new, dist.risk.factors, snp.info){
  if( covs_in_model){
    
    if(is.null(genotype.new)){
      genotype.new = matrix(ncol = nrow(snp.info), nrow = nrow(cov.new), NA)
      print("You included snp_info, but did not provide genotype.new.  Will impute all SNPs. ")
    }
    if(nrow(genotype.new)!=nrow(cov.new)){
      print("cov.new and genotype.new must have same number of rows. ")
      stop()
    } 
    if(!is.na(bin.fh.name)){
      if( !is.element( bin.fh.name, colnames(cov.new)) ){
        print("WARNING: bin.fh.name must contain the variable name of family history (matching a column name in cov.new) if it is in the model, otherwise NA.")
        stop()        
      }else{
        fh.pop = dist.risk.factors[,bin.fh.name]
        fh.cov = cov.new[,bin.fh.name]
        attenuate.fh = 1
        if( prod(is.element(fh.pop, c(0,1,"0", "1", NA)) ) == 0){
          print("WARNING: The family history must be binary when using snp_info functionality. Check input for dist.risk.factors.")
          stop()     
        }
        if( prod(is.element(fh.cov, c(0,1,"0", "1", NA)) ) == 0){
          print("WARNING: The family history must be binary when using snp_info functionality. Check input for cov.new.")
          stop()     
        }}
    }else{ # bin.fh.name = NA - family history not in the model
      fh.pop = rep(0, nrow( dist.risk.factors))
      fh.cov = rep(0, nrow( cov.new)) 
      attenuate.fh = 0
      print("Note: As specified, the model does not adjust SNP imputations for family history, as bin.fh.name = NA.")
    }
  }else{
    fh.pop = rep(0, nrow( genotype.new))
    fh.cov = rep(0, nrow( genotype.new)) 
    attenuate.fh = 0
    print("Note: As specified, the model does not adjust SNP imputations for family history.")
  }
  res <- list(); res[[1]] = attenuate.fh; res[[2]] = fh.pop; res[[3]] = fh.cov; res[[4]] = genotype.new; res
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
  if(!is.matrix(mat)){
    print(paste("WARNING: ", name, " must be provided as a matrix.", sep=""))
    stop()
  }
  if(ncol(mat)!=3 & ncol(mat)!=2){
    print(paste("WARNING: ", name, " must have either 2 columns: [Ages,Rates] or 3 columns:[Start_Ages, End_Ages, Rates].", sep=""))  
    stop()
  }
  ll = nrow(mat)
  if(ll>1 & ncol(mat)==3){
    if(sum(mat[2:ll,1] - mat[1:(ll-1),2]-1)!=0){
      print(paste("WARNING: The rates provided in ", name, " must cover sequential age intervals (i.e. if an interval ends at age 30, the next interval must start at age 31).", sep=""))  
      stop()
    }
  }
  if(ncol(mat)==2 && sum(mat[,1]%%1)!=0){
    print(paste("WARNING: The first column of ", name, " should be integer ages.", sep=""))
    stop()
  }
  if(sum(mat[,ncol(mat)]<0, na.rm=T) + sum(mat[,ncol(mat)]>1, na.rm=T)!=0){
    print("WARNING: The rates should be probabilities between 0 and 1.")  
    stop()
  }
  format_flexible_rate_inputs(mat)
}

check_rates <- function(competing.incidence.rates, lambda, age.new, age.interval){
  
  lambda = check_flexible_rate_inputs(lambda, "population.incidence.rates")
  
  if(is.null(competing.incidence.rates)){  competing.incidence.rates= cbind(lambda[,1], rep(0, length(lambda[,1])))   }
  
  competing.incidence.rates = check_flexible_rate_inputs(competing.incidence.rates, "competing.incidence.rates")
  
  if( prod(is.element(seq(range(age.new)[1], range(age.new + age.interval)[2]), lambda[,1])) == 0){
    print("WARNING: The 'population.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'age.new' and 'age.interval.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  if( prod(is.element(seq(range(age.new)[1], range(age.new + age.interval)[2]), competing.incidence.rates[,1])) == 0){
    print("WARNING: The 'competing.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'age.new' and 'age.interval.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  res=list(); res[[1]] = lambda; res[[2]] = competing.incidence.rates; res
}

check_model_inputs <- function(cov.new, beta.given, dist.risk.factors, dist.weights, triple.check, model.predictor, n.imp){
  if(length(n.imp)!=1){
    print("WARNING: n.imp must be a single integer.")
    stop()
  }
  if( (n.imp < 1) || (n.imp > 20) ){
    print("WARNING: n.imp must be a single integer between 0 and 20.")
    stop()
  }
  if(is.data.frame(cov.new)!=TRUE){
    print("WARNING: cov.new must be a dataframe.")
    stop()
  }
  if(is.data.frame(dist.risk.factors)!=TRUE){
    print("WARNING: dist.risk.factors must be a dataframe (with appropriate column names).")
    stop()
  }
  if(sum(rowSums(is.na(dist.risk.factors)))>0){
    print("WARNING: dist.risk.factors cannot contain NAs.")
    stop()
  }
  check_triple_check(triple.check)
  triple.check = process_triple_check(triple.check)
  
  ### Will verify all names and proper order of things against triple.check - so check against model first
  if(is.null(colnames(triple.check))){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  if(length(colnames(triple.check))!=length(all.vars(model.predictor)[2:length(all.vars(model.predictor))])){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  if( sum(colnames(triple.check)!=all.vars(model.predictor)[2:length(all.vars(model.predictor))])>0 ){
    print("WARNING: triple.check must have same names and order as predictors in model.predictor.")
    stop()
  }
  if(prod(colnames(triple.check)==colnames(cov.new))!=1){
    print("WARNING: Variable names of triple.check should match column names of cov.new.")
    stop()
  }
  for(k in 1:ncol(triple.check)){
    if(is.factor(triple.check[,k])){
      if(sum(is.element(cov.new[,k], triple.check[,k])+(is.na(c(cov.new[,k])))==0)>0){
        print(paste("WARNING: cov.new categorical Variable (", colnames(triple.check)[k] ,") has levels outside levels modeled."))
        stop()
      }
    }
  }
  if(prod(colnames(triple.check)==colnames(dist.risk.factors))!=1){
    print("WARNING: Variable names of triple.check should match column names of dist.risk.factors.")
    stop()
  }
  if(nrow(dist.risk.factors) < 200){
    print(paste("WARNING: Samples in referent distribution dist.risk.factors should be large.  Currently only size ", nrow(dist.risk.factors),".", sep=""))
  }
  if(is.null(dist.weights)){
    dist.weights = rep(1/nrow(dist.risk.factors), nrow(dist.risk.factors))
  }else{
    if(length(dist.weights)!=nrow(dist.risk.factors)){
      print("WARNING: If dist.weights is provided it must be same length as the number of rows in dist.risk.factors.")
      stop()
    }
    if( sum((dist.weights<0), na.rm=T)!=0){
      print("WARNING: dist.weights must not contain negative values.")
      stop()
    }
    dist.weights = dist.weights / sum(dist.weights, na.rm=T)
  }
  ## for now don't allow NA's here
  for(k in 1:ncol(triple.check)){
    if(is.factor(triple.check[,k])){
      if(sum(is.element(c(dist.risk.factors[,k]), triple.check[,k])==0)>0){
        print(paste("WARNING: dist.risk.factors categorical Variable (", colnames(triple.check)[k] ,") has levels outside levels modeled."))
        stop()
      }
    }
  }
  variables <- unique(all.vars(model.predictor))[-1]
  data_use  <- subset(triple.check, select = variables)
  
  if(is.vector(beta.given)==FALSE & is.matrix(beta.given)==FALSE){
    print("WARNING: beta.given must be either a vector, or a matrix with only one column.")
    stop() 
  }
  if(is.matrix(beta.given)==TRUE){
    if(dim(beta.given)[2]>1){
      print("WARNING: beta.given must be either a vector, or a matrix with only one column.")
      stop()
    }
  }
  if(is.vector(beta.given)==TRUE){
    temp = names(beta.given)
    beta.given = cbind(beta.given)
    rownames(beta.given) = temp
  }
  res = list(); res[[1]] = data_use; res[[2]] = beta.given; res[[3]] = dist.weights; res
}

check_design_matrix <- function(beta.given, design_covs){
  
    if(is.null(rownames(beta.given)) ){
      print("WARNING: row names of beta.given must match names and order in design matrix.")
      print(paste("Row names of beta.given = NULL"))
      print(paste("Names of design_matrix = ", paste0(colnames(design_covs), collapse=", ") ))
      stop()
    }
    if( sum( rownames(beta.given)!= colnames(design_covs) )>0){
      print("WARNING: row names of beta.given must match names and order in design matrix.")
      print(cbind(names(beta.given), colnames(design_covs)))
      stop()
    }
  }

check_age_lengths <- function(age.new, age.interval, match, match_name){
  
  if(length(age.new)==1){
    age.new = rep(age.new, nrow(match))
  }
  if(length(age.interval)==1){
    age.interval = rep(age.interval, nrow(match))
  }
  if(length(age.new)!=length(age.interval)){
    print("WARNING: age.new and age.interval must have the same length.")
    stop()
  }
  if(length(age.new) != nrow(match)){
    print(paste("WARNING: age.new and number of rows of ", match_name," must match.", sep=""))
    stop()
  }
  if(sum(is.na(age.new)+is.na(age.interval))>0){
    print("WARNING: age.new and age.interval may not contain missing values.")
    stop()
  }
  if(sum((age.new<0)+(age.interval<0))>0){
    print("WARNING: age.new and age.interval must contain positive values.")
    stop()
  }
  res <- list(); res[[1]] = age.new; res[[2]] = age.interval; res
}

handle_missing_SNPs_and_covs <- function(miss_w_some_SNPs_miss, Z_new, snps.betas, snps.freqs, age.new, age.interval,
                                         lambda_0, beta_est, competing.incidence.rates, fh.cov, ref_pop, pop.weights, use.c.code, ncuts){
  
  hold_risks <- matrix(NA, nrow = length(miss_w_some_SNPs_miss), ncol = 5)
  for(i in 1:5){
    complete_Z_new <- subset(Z_new, select = miss_w_some_SNPs_miss)
    these          <- which(is.na(complete_Z_new[1:length(snps.betas), ])==1)
    complete_Z_new[1:length(snps.betas), ][these] <-  t( sim_snps(snps.betas, snps.freqs, fh.cov[miss_w_some_SNPs_miss]) )[these]
    hold_risks[,i]                                <- comp_Aj(complete_Z_new, age.new[miss_w_some_SNPs_miss], age.interval[miss_w_some_SNPs_miss], lambda_0, beta_est, competing.incidence.rates)
    
    if(sum(is.na(hold_risks[,i]))>0){
      miss2          <- which(is.na(hold_risks[,i])==1)
      present2       <- which(is.na(hold_risks[,i])==0)
      hold_risks[,i] <- handle_missing_data(use.c.code, age.new, age.interval, complete_Z_new, miss2, present2, ncuts, hold_risks[,i], ref_pop, pop.weights, lambda_0, beta_est, competing.incidence.rates)
    }
  }
  rowMeans(hold_risks)
}

package_results <- function(final_risks, covs_in_model, handle.snps, age.new, age.interval, cov.new, 
                            beta.given, beta_est, genotype.new, snps.names, return.lp ){
  result <-list()
  result$risk           <- cbind(as.vector(final_risks))
  colnames(result$risk) <- c("Risk_Estimate")
  
  if(covs_in_model){
    if(handle.snps==0){
      info = cbind(as.vector(age.new), as.vector(age.new + age.interval), cov.new, as.vector(final_risks))
      colnames(info) = c("Int_Start", "Int_End", colnames(cov.new), "Risk_Estimate")
      beta.names = rownames(beta.given)
    }else{
      info = cbind(as.vector(age.new), as.vector(age.new + age.interval), cbind( genotype.new, cov.new), as.vector(final_risks))
      colnames(info) = c("Int_Start", "Int_End", snps.names, colnames(cov.new), "Risk_Estimate")  
      beta.names = c( snps.names, rownames(beta.given) )
    }
  }else{
    info = cbind(as.vector(age.new), as.vector(age.new + age.interval), genotype.new, as.vector(final_risks))
    colnames(info) = c("Int_Start", "Int_End", snps.names, "Risk_Estimate")  
    beta.names =  snps.names
  }
  result$details = info
  beta.used = beta_est
  rownames(beta.used) <- beta.names
  colnames(beta.used) <- "log OR used"
  result$beta.used    <- beta.used
  
  if(return.lp==T){
    result$lps <- t(Z_new)%*%beta_est
  }
  result
}

get_refs_risk <- function(ref_pop, age.interval, lambda_0, beta_est, competing.incidence.rates, handle.snps ){
  
  refs.risk = comp_Aj(ref_pop, age.new[1], age.interval[1], lambda_0, beta_est, competing.incidence.rates)
  if(handle.snps){
    refs.risk = rowMeans( matrix(refs.risk, ncol=5, nrow=length(refs.risk)/5, byrow=F))
  }
  refs.risk
}

PRS.research <- function(age.new, age.interval, population.incidence.rates, use.c.code = 1, 
                         competing.incidence.rates = NULL, variance.explained, N = 10000, 
                         predict.stand.vals = NULL){
  
  if(length(age.new)!=1 || length(age.interval)!=1){
    print("WARNING:  You may only choose one value for age.new and one value for age.interval.")
  }
  age.new      <- rep(age.new, N)
  age.interval <- rep(age.interval, N)
  lambda       <- population.incidence.rates
  if(is.null(competing.incidence.rates)){  competing.incidence.rates= cbind(lambda[,1], rep(0, length(lambda[,1])))   }
  
  if(ncol(lambda)!=2){ print("WARNING: population.incidence.rates should have 2 columns: [Ages,Rates]") }
  
  if(ncol(competing.incidence.rates)!=2){ print("WARNING: competing.incidence.rates should have 2 columns: [Ages,Rates]") }
  
  if(sum(lambda[,1]%%1)!=0){ print("WARNING: The first column of population.incidence.rates should be integer ages.")  }
  
  if(sum(competing.incidence.rates[,1]%%1)!=0){ print("WARNING: The first column of competing.incidence.rates should be integer ages.")  }
  if( prod(is.element(seq(range(age.new)[1], range(age.new+age.interval)[2]), lambda[,1])) == 0){
    print("WARNING: The 'population.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'age.new' and 'age.interval.'  You must make these inputs consistent with one another to proceed.")
    stop()
  }
  if( prod(is.element(seq(range(age.new)[1], range(age.new+age.interval)[2]), competing.incidence.rates[,1])) == 0){
    print("WARNING: The 'competing.incidence.rates' input must have age-specific rates for each integer age covered by the prediction intervals defined by 'age.new' and 'age.interval.'  You must make these inputs consistent with one another to proceed.")
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
  final_risks <- comp_Aj(Z_new, age.new, age.interval, lambda_0, beta_est, competing.incidence.rates)
  
  if(is.null(predict.stand.vals)==0){
    
    if(is.vector(predict.stand.vals)==0){
      print("WARNING: predict.stand.vals must be a vector")
    }else{
      temp = t(cbind(predict.stand.vals))
      specific_risks <- comp_Aj(temp, age.new[1:length(predict.stand.vals)], age.interval[1:length(predict.stand.vals)], lambda_0, beta_est, competing.incidence.rates)
    }    
  }
  results      <- list()
  results$risk <- final_risks
  if(is.null(predict.stand.vals)==0){
    results$predictions.for.stand.vals <- specific_risks
  }
  results
}




