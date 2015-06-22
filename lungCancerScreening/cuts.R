cuts <- function(data,npieces,simple.labels=T,...) {
  # A wrapper to the cut() function, so that you can automatically break into quantiles as
  # the default behavior, otherwise if the breakpoints are included, then just break on
  # those.
  # In all cases, I always set include.lowest to True

  if (length(npieces)==0 | any(is.na(npieces)) | any(!is.numeric(npieces)))
    stop("npieces must be a numeric scalar or a vector of breakpoints")
  
  if (length(npieces)==1)
    # Just break into quantiles.  Use quantile labelling: Q1,Q2,Q3,etc. if you want
    if (simple.labels)
      cutdata <- cut(data,breaks=quantile(data,seq(0,1,1/npieces),na.rm=T,...),
                     include.lowest=T,labels=paste("Q",1:npieces,sep=""),...)
    else
      cutdata <- cut(data,breaks=quantile(data,seq(0,1,1/npieces),na.rm=T,...),
                     include.lowest=T,...)
  else
    # Break into pieces as specified by the breakpoints
    if (simple.labels)
      cutdata <- cut(data,breaks=npieces,include.lowest=T,
                     labels=paste("Q",1:(length(npieces)-1),sep=""),...)
    else
      cutdata <- cut(data,breaks=npieces,include.lowest=T,...)
  
  return(cutdata)
}
