PPVNPVprobM_abcd <- function(PPV,NPV,probM,total) {
  probDM <- PPV*probM
  probDnotM <- (1-NPV)*(1-probM)
  probnotDM <- (1-PPV)*probM
  probnotDnotM <- NPV*(1-probM)
  a <- probDM*total
  b <- probDnotM*total
  c <- probnotDM*total
  d <- probnotDnotM*total
  abcd <- c(a,b,c,d)
  if(a > 0 && b > 0 && c > 0 && d > 0) {
    return(abcd)
  }
  else {
    return("Error")
  }
}

PPVNPVprobD_abcd <- function(PPV,NPV,probD,total) {
  probM <- (probD - (1-NPV))/(PPV-(1-NPV))
  PPVNPVprobM_abcd(PPV,NPV,probM,total)
}

sensspecprobD_abcd <- function(sens,spec,probD,total) {
  probDM <- sens*probD
  probDnotM <- (1-sens)*probD
  probnotDM <- (1-spec)*(1-probD)
  probnotDnotM <- spec*(1-probD)
  a <- probDM*total
  b <- probDnotM*total
  c <- probnotDM*total
  d <- probnotDnotM*total
  abcd <- c(a,b,c,d)
  if(a > 0 && b > 0 && c > 0 && d > 0) {
    return(abcd)
  }
  else {
    return("Error")
  }
}

sensspecprobM_abcd <- function(sens,spec,probM,total) {
  probD <- (1-probM-spec)/(1-sens-spec)
  sensspecprobD_abcd(sens,spec,probD,total)
}

MRSunconditional <- function(abcd) {
  ## Purpose: Estimate MRS statistics and their unconditional quadrinomial variance estimates: 
  ## ----------------------------------------------------------------------
  ## Arguments: 4 cells plus 1 margin
  ## ----------------------------------------------------------------------
  ## Author: Hormuzd Katki, Date: 11 6 14
  
  a <- abcd[1]
  b <- abcd[2]
  c <- abcd[3]
  d <- abcd[4]
  
  Mpos <- a+c ; Mneg <- b+d
  n <- Mpos+Mneg
  # Set sampling fractions and weights from old code to 1
  # This is so I don't have to change the variance calculations for % agreement and Kappa
  # and will facilitate future calculations with weighted data
  pineg <- 1 ; pipos <- 1 ; wneg <- 1/pineg    ;  wpos <- 1/pipos
  # Unfixed margins
  Dpos <- a*wpos+b*wneg ; Dneg <- c*wpos+d*wneg
  # Variance of a given a+c, and of d given b+d:  npq binomial variances * weight^2
  Va <- (a+c)*(a/(a+c))*(c/(a+c))*wpos^2 ; Vd <- (b+d)*(d/(b+d))*(b/(b+d))*wneg^2
  Vc <- Va; Vb <- Vd #by binomial, same variances for x or n-x
  
  ##
  # Meat of the unconditional quadrinomial-based delta-method variance
  ##
  pa <- a/n ; pb <- b/n ; pc <- c/n ; pd <- d/n
  V <- (1/n)*matrix(c(pa*(1-pa),-pa*pb,-pa*pc,-pa*pd,
                      -pb*pa,pb*(1-pb),-pb*pc,-pb*pd,
                      -pc*pa,-pc*pb,pc*(1-pc),-pc*pd,
                      -pd*pa,-pd*pb,-pd*pc,pd*(1-pd)),nrow=4,ncol=4,byrow=TRUE)
  
  
  # Compute the log(OR) and its variance
  OR <- a*d/b/c
  selogOR <- sqrt(1/a+1/b+1/c+1/d)
  # Add 0.5 to all cells if zero cells are a problem
  # logOR <- log(((b+0.5)*wneg)/((c+0.5)*wpos))
  # VlogOR <- ((b+0.5)*wneg)^-2 * Vb + ((c+0.5)*wpos)^-2 * Vc
  ORCI <- OR+1.96*c(-selogOR,selogOR)
  
  
  # Compute PPV and NPV and sensitivity and specificity
  PPV <- a*wpos/Mpos ;  NPV <- d*wneg/Mneg
  sens <- a*wpos/Dpos ; spec <- d*wneg/Dneg
  
  delPPV <- c(pc/(pc+pa)^2,
              0,
              -pa^-1*(1+pc/pa)^-2,
              0)
  VPPV <- t(delPPV) %*% V %*% delPPV
  
  delNPV <- c(0,
              -pd^-1*(1+pb/pd)^-2,
              0,
              pb/(pb+pd)^2)
  VNPV <- t(delNPV) %*% V %*% delNPV
  
  delsens <- c(pb/(pb+pa)^2,
               -pa^-1*(1+pb/pa)^-2,
               0,
               0)
  Vsens <- t(delsens) %*% V %*% delsens
  
  delspec <- c(0,
               0,
               -pd^-1*(1+pc/pd)^-2,
               pc/(pc+pd)^2)
  Vspec <- t(delspec) %*% V %*% delspec
  
  Youden <- sens+spec-1
  delYouden <- delsens+delspec
  VYouden <- t(delYouden) %*% V %*% delYouden
  
  AUC <- (Youden+1)/2
  VAUC <- VYouden/4
  
  PPVCI <- PPV+1.96*c(-sqrt(VPPV),sqrt(VPPV))
  
  cNPVCI <- (1-NPV)+1.96*c(-sqrt(VNPV),sqrt(VNPV))

  sensCI <- sens+1.96*c(-sqrt(Vsens),sqrt(Vsens))
  
  specCI <- spec+1.96*c(-sqrt(Vspec),sqrt(Vspec))
  
  YoudenCI <- Youden+1.96*c(-sqrt(VYouden),sqrt(VYouden))
  
  AUCCI <- AUC+1.96*c(-sqrt(VAUC),sqrt(VAUC))
  
  
  ##
  # Compute the new risk stratification distribution statistics
  ##
  
  p <- (a+c)/n  # Marker positivity
  q <- (a+b)/n # Disease prevalence
  
  delp <- c(1,0,1,0)
  Vp <- t(delp) %*% V %*% delp
  
  delq <- c(1,1,0,0)
  Vq <- t(delq) %*% V %*% delq
  
  pCI <- p+1.96*c(-sqrt(Vp),sqrt(Vp))
  
  qCI <- q+1.96*c(-sqrt(Vq),sqrt(Vq))
  
  
  # Danger and reassurance
  danger <- PPV - q
  deldanger <- c(1 - 1/(pa+pc) + pa*(pa+pc)^-2,
                 1 + pa*(1-1/(pa+pc)),
                 pa*(pa+pc)^-2,
                 0)
  Vdanger <- t(deldanger) %*% V %*% deldanger
  
  reassurance <- q - (1-NPV)
  delreassurance <- c(1 + pb*(1-1/(pb+pd)),
                      1 - 1/(pb+pd) + pb*(pb+pd)^-2,
                      0,
                      pb*(pb+pd)^-2)
  Vreassurance <- t(delreassurance) %*% V %*% delreassurance
  
  dangerCI <- danger+1.96*c(-sqrt(Vdanger),sqrt(Vdanger))
  
  reassuranceCI <- reassurance+1.96*c(-sqrt(Vreassurance),sqrt(Vreassurance))
  
  # MRS and risk difference t
  MRS <- 2*(danger+reassurance)*p*(1-p)
  VMRS <- 4*p^2*Vdanger
  
  t <- danger+reassurance
  Vt <- Va/Mpos^2 + Vb/Mneg^2
  
  MRSCI <- MRS+1.96*c(-sqrt(VMRS),sqrt(VMRS))
  
  tCI <- t+1.96*c(-sqrt(Vt),sqrt(Vt))
  
  # Population burden stratification D
  D <- a/(a+b+c+d) - b/(a+b+c+d)
  VD <- Va/n^2 + Vb/n^2
  
  DCI <- D+1.96*c(-sqrt(VD),sqrt(VD))
  
  
  # Danger* and Reassurance*
  
  dangerstar <- sens - p
  reassurancestar <- spec - (1 - p)
  rr <- PPV/(1-NPV)
  nnr <- 1/D
  maxMRS <- 2*q*(1-q)
  nns <- 1/t
  
  # Probabilities
  
  probDM <- a/n
  probDnotM <- b/n
  probnotDM <- c/n
  probnotDnotM <- d/n
  
  # output
  paramrows <- c("a","b","c","d","P(D+,M+)", "P(D+,M-)","P(D-,M+)","P(D-,M-)","Marker Positivity","Disease Prevalence","Positive Predictive Value","complement of the Negative Predictive Value","Sensitivity","Specificity","complement of the Specificity","RR","Risk Difference", "Youden","Area Under the Curve")
  parameters <- matrix(c(a,b,c,d,probDM,probDnotM,probnotDM,probnotDnotM,p,q,PPV,(1-NPV),sens,spec,(1-spec),rr,t,Youden,AUC,rep(NA,8),pCI[1],qCI[1],PPVCI[1],cNPVCI[1],sensCI[1],specCI[1],rep(NA,2),tCI[1],YoudenCI[1],AUCCI[1],rep(NA,8),pCI[2],qCI[2],PPVCI[2],cNPVCI[2],sensCI[2],specCI[2],rep(NA,2),tCI[2],YoudenCI[2],AUCCI[2]),nrow=length(paramrows),ncol=3,byrow=F)         
  rownames(parameters) <- paramrows
  colnames(parameters) <- c("Value","Confidence Interval (lower bound)", "Confidence Interval (upper bound)")
  calcrows <- c("Danger","Reassurance","Quality of the sensitvity","Quality of the specificity","Mean Risk Stratification","Maximum possible MRS", "Population Burden Stratification","Number Needed to Recruit","Number Needed to Screen")
  calculations <- matrix(c(danger,reassurance,dangerstar,reassurancestar,MRS,maxMRS,D,nnr,nns,dangerCI[1],reassuranceCI[1],NA,NA,MRSCI[1],NA,DCI[1],NA,NA,dangerCI[2],reassuranceCI[2],NA,NA,MRSCI[2],NA,DCI[2],NA,NA),nrow=length(calcrows),ncol=3,byrow=F)
  rownames(calculations) <- calcrows
  colnames(calculations) <- c("Value","Confidence Interval (lower bound)", "Confidence Interval (upper bound)")
  output <- list(parameters,calculations)
  
  # End
  return(output)
  
}