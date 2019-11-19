risk.kovalchik <- 
function (begin, end, newdata, coxph1, ...) 
{
    #calculate absolute risk given hazards/survival and relative risks
    risk.fixed.interval <- function(H, RR) {
        if (!is.list(H)) 
            0
        else {
            absrisk <- H[[1]]$surv^RR[1] * H[[1]]$haz * RR[1]
            for (i in 2:length(H)) {
                absrisk <- absrisk * (H[[i]]$surv^RR[i])
            }
            sum(absrisk)
        }
    }
    
    models <- c.coxph.risk(coxph1, ...)
    
    #check for missing
    which.kept <- complete.cases(newdata)
    if (!all(which.kept)) {
        warning("Missing cases excluded.")
        if (length(begin) > 1) {
            begin <- begin[which.kept]
            end <- end[which.kept]
        }
        newdata <- newdata[which.kept, ]
    }

    #calculate relative risk for each subject and store as list
    rr <- sapply(models, projection.relrisk, data = newdata)

    if (is.matrix(rr))
        rr.list <- lapply(1:nrow(rr), function(x) rr[x, ])
    else rr.list <- list(rr)

    #estimate risk
    if (length(begin) == 1) {
        H <- coxph.risk.baseline(begin, end, models)   #hazard for each timepoint for lung cancer death and other deaths
        risks <- mapply(risk.fixed.interval, RR = rr.list, MoreArgs = list(H = H))
    }
    else {
        risks <- mapply(risk, begin = begin, end = end, RR = rr.list, 
            MoreArgs = list(models = models))
    }
    risks
}

