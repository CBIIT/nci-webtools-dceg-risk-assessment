MRSunconditional <- function(a,b,c,d)
{
## Purpose: Estimate MRS statistics and their unconditional quadrinomial variance estimates: 
## ----------------------------------------------------------------------
## Arguments: 4 cells plus 1 margin
## ----------------------------------------------------------------------
## Author: Hormuzd Katki, Date: 11 6 14

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

# output
columnnames <- c("pctagree","stderr","pctposagree","stderr","pctnegagree","stderr",
                 "Kappa","stderr","McNemarH0","McNemarTest","pvalue","logOR",
                 "stderrlogOR","PPV","stderr","cNPV","stderr","sens","stderr","spec",
                 "stderr","Youden","stderr","AUC","stderr","positivity","stderr",
                 "prevalence","stderr","danger","stderr",
                 "reassurance","stderr","MRS","stderr","risk diff","stderr","Pop risk diff","stderr")
output <- matrix(NA,nrow=1,ncol=length(columnnames))
colnames(output) <- columnnames 

##
# Meat of the unconditional quadrinomial-based delta-method variance
##
pa <- a/n ; pb <- b/n ; pc <- c/n ; pd <- d/n
V <- (1/n)*matrix(c(pa*(1-pa),-pa*pb,-pa*pc,-pa*pd,
                    -pb*pa,pb*(1-pb),-pb*pc,-pb*pd,
                    -pc*pa,-pc*pb,pc*(1-pc),-pc*pd,
                    -pd*pa,-pd*pb,-pd*pc,pd*(1-pd)),nrow=4,ncol=4,byrow=TRUE)

##
# % agreement
##
pctagree <- (a*wpos + d*wneg)/n
Vpctagree <- (Va + Vd)/n^2
stderr <- sqrt(Vpctagree)
z <- pctagree/stderr
p <- 2*(1-pnorm(z,0,1))
CI <- pctagree+1.96*c(-stderr,stderr)
#cat("% agree:",pctagree,"stderr:",stderr,"Z:",z,"p:",p,"CI:",CI,"\n")

output[1,1:2] <- c(pctagree,stderr)

##
# % positive and negative agreement
##
pctposagree <- a*wpos / (Mpos+b*wneg)
Vpctposagree <- (Mpos+b*wneg)^-2 *(Va + Vd*pctposagree^2) 
stderr <- sqrt(Vpctposagree)
z <- pctposagree/stderr
p <- 2*(1-pnorm(z,0,1))
CI <- pctposagree+1.96*c(-stderr,stderr)
#cat("% positive agree:",pctposagree,"stderr:",stderr,"Z:",z,"p:",p,"CI:",CI,"\n")

output[1,3:4] <- c(pctposagree,stderr)

pctnegagree <- d*wneg / (Mneg+c*wpos)
Vpctnegagree <- (Mneg+c*wpos)^-2 *(Vd + Va*pctnegagree^2) 
stderr <- sqrt(Vpctnegagree)
z <- pctnegagree/stderr
p <- 2*(1-pnorm(z,0,1))
CI <- pctnegagree+1.96*c(-stderr,stderr)
#cat("% negative agree:",pctnegagree,"stderr:",stderr,"Z:",z,"p:",p,"CI:",CI,"\n")

output[1,5:6] <- c(pctnegagree,stderr)

##
# Kappa
##
P0 <- pctagree
Pe <- Mpos*Dpos/n^2 + Mneg*Dneg/n^2
Kappa <- (P0-Pe)/(1-Pe)

# Here are the pieces for variance of kappa
VP0 <- Vpctagree
VPe <- (Mpos/n)^2*(Va+Vd)/n^2 +
       (Mneg/n)^2*(Vd+Va)/n^2 + 2*Mpos*Mneg*n^-4 * (-Va - Vd)
CovP0Pe <- n^-3*(Va*(Mpos-Mneg) + Vd*(Mneg-Mpos))

# Compute variance of kappa from delta method asymptotic variance of the transformation:
# (P0,Pe) -> (P0-Pe)/(1-Pe)
# VKappa <- (1-Pe)^-2*(VP0+VPe-2*CovP0Pe - 2*Kappa*(VPe-CovP0Pe) + Kappa^2*VPe)
VKappa <- (1-Pe)^-2*(VP0 + 2*CovP0Pe*(Kappa-1) + VPe*(Kappa-1)^2)
stderr <- sqrt(VKappa)
z <- Kappa/stderr
p <- 2*(1-pnorm(z,0,1))
CI <- Kappa+1.96*c(-stderr,stderr)
#cat("Kappa:",Kappa,"stderr:",stderr,"Z:",z,"p:",p,"CI:",CI,"\n")

output[1,7:8] <- c(Kappa,stderr)

# Now compute McNemar's test under sampling
# I compute the usual test statistic, but instead of comparing to a null of zero, compare
# it to the null you expect to see in your sample due to sampling.  It is a constant since
# it only depends on fixed quantities: the sum of the diagonal and the sum of all 4 cells.
# H0 is the difference under the null between the A-,B+ (n_21) and the A+,B- (n_12) cells
H0 <- (b+c) * (pineg-pipos)/(pipos+pineg)
McNemar <- (b-c-H0)^2/(b+c)
McNpval <- 1-pchisq(McNemar,1)

output[1,9:11] <- c(H0,McNemar,McNpval)

# Compute the log(OR) and its variance
logOR <- log((b*wneg)/(c*wpos))
VlogOR <- (b*wneg)^-2 * Vb + (c*wpos)^-2 * Vc
# Add 0.5 to all cells if zero cells are a problem
# logOR <- log(((b+0.5)*wneg)/((c+0.5)*wpos))
# VlogOR <- ((b+0.5)*wneg)^-2 * Vb + ((c+0.5)*wpos)^-2 * Vc

output[1,12:13] <- c(logOR,sqrt(VlogOR))


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

output[1,14:25] <- c(PPV,sqrt(VPPV),1-NPV,sqrt(VNPV),sens,sqrt(Vsens),spec,sqrt(Vspec),
                     Youden,sqrt(VYouden),AUC,sqrt(VAUC))


##
# Compute the new risk stratification distribution statistics
##

p <- (a+c)/n  # Marker positivity
q <- (a+b)/n # Disease prevalence

delp <- c(1,0,1,0)
Vp <- t(delp) %*% V %*% delp

delq <- c(1,1,0,0)
Vq <- t(delq) %*% V %*% delq
output[1,26:29] <- c(p,sqrt(Vp),q,sqrt(Vq))

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

output[1,30:33] <- c(danger,sqrt(Vdanger),reassurance,sqrt(Vreassurance))

# MRS and risk difference t
MRS <- 2*danger*p
VMRS <- 4*p^2*Vdanger

t <- danger+reassurance
Vt <- Va/Mpos^2 + Vb/Mneg^2

output[1,34:37] <- c(MRS,sqrt(VMRS),t,sqrt(Vt))

# Population risk difference D
D <- a/n - b/n
VD <- Va/n^2 + Vb/n^2

output[1,38:39] <- c(D,sqrt(VD))

# End
return(output)

}
