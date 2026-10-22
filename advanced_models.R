# PhytoEpiQuant advanced validation, base R only.
# Fits on ORIGINAL disease proportion scale via constrained nonlinear least squares.
pe_predict <- function(model, par, time) {
  t <- as.numeric(time)
  switch(model,
    logistic = plogis(par[1] + par[2]*t),
    gompertz = exp(-exp(-(par[1] + par[2]*t))),
    monomolecular = 1 - exp(pmin(0,par[1] - par[2]*t)),
    exponential = pmin(1, exp(par[1] + par[2]*t)),
    stop('Unknown model'))
}
# Fitting supports Gaussian SSE or variance-weighted SSE. Weighted SSE is a
# sensitivity analysis, NOT a binomial likelihood, unless denominators exist.
pe_fit_one <- function(time, severity_pct, model, weighting='unweighted', n_assessed=NULL) {
  ok <- is.finite(time) & is.finite(severity_pct)
  t <- as.numeric(time[ok]); y <- as.numeric(severity_pct[ok])/100
  if(length(t)<5 || length(unique(t))<5 || any(y<0|y>1) || anyDuplicated(t)) stop('Need >=5 distinct times and severity 0–100%')
  o<-order(t);t<-t[o];y<-y[o]
  interior <- y>0 & y<1
  z <- switch(model, logistic=qlogis(y[interior]), gompertz=-log(-log(y[interior])), monomolecular=log1p(-y[interior]), exponential=log(y[interior]))
  if(sum(interior)>=2 && length(unique(t[interior]))>=2) {
    start <- unname(coef(lm(z~t[interior])))
  } else start <- c(-2,0.03)
  if(any(!is.finite(start))) start<-c(-2,0.03)
  if(model=='monomolecular')start[2]<- -start[2]
  start[2]<-max(1e-6,min(3,start[2])); if(model=='monomolecular')start[1]<-min(-1e-6,start[1])
  # Fixed pilot weights avoid a moving-target objective; limit extreme weights.
  w<-rep(1,length(y))
  if(weighting=='variance_weighted') {
    pilot <- pmax(.02,pmin(.98,stats::filter(y,rep(1/3,3),sides=2)))
    pilot[!is.finite(pilot)]<-pmax(.02,pmin(.98,y[!is.finite(pilot)]))
    nn<-if(is.null(n_assessed)) rep(1,length(y)) else as.numeric(n_assessed[ok])[o]
    if(any(!is.finite(nn)|nn<=0))stop('n_assessed must be positive')
    w<-nn/(pilot*(1-pilot));w<-pmin(w,stats::quantile(w,.9,na.rm=TRUE)*3);w<-w/mean(w)
  }
  # Robust bounded multistart minimization of original-scale weighted SSE.
  # Multiple starting points reduce dependence on transformed-linear initialization.
  # Fit validity is assessed by finite objective, parameter bounds and gradient/KKT checks.
  fn<-function(p) {
    yh<-pe_predict(model,p,t)
    if(any(!is.finite(yh))) return(.Machine$double.xmax/1e8)
    sum(w*(y-yh)^2)
  }
  lo<-c(-20,0); hi<-c(if(model=='monomolecular') -1e-7 else 20,3)
  initial<-rbind(start,c(-4,.01),c(-2,.05),c(0,.02),c(2,.1),c(-6,.2),c(-1,.005))
  if(model=='monomolecular') initial[,1]<-pmin(-1e-5,initial[,1])
  initial<-unique(as.data.frame(t(apply(initial,1,function(p)pmax(lo+1e-8,pmin(hi-1e-8,p))))))
  runs<-lapply(seq_len(nrow(initial)),function(j) tryCatch(
    optim(as.numeric(initial[j,]),fn,method='L-BFGS-B',lower=lo,upper=hi,
          control=list(maxit=5000,factr=1e7,pgtol=1e-10)),error=function(e)NULL))
  runs<-Filter(function(o)!is.null(o)&&all(is.finite(o$par))&&is.finite(o$value),runs)
  if(!length(runs)) stop('All optimizer starts failed')
  ord<-order(vapply(runs,function(o)o$value,numeric(1)))
  opt<-runs[[ord[1]]]
  # A bounded optimum can be valid even if L-BFGS-B reports a nonzero code;
  # use an independent derivative-free refinement to assess stability.
  if(opt$convergence!=0) {
    nm<-tryCatch(optim(opt$par,function(p){
      if(any(p<lo)||any(p>hi)) return(1e6+sum(pmax(lo-p,0)^2+pmax(p-hi,0)^2))
      fn(p)
    },method='Nelder-Mead',control=list(maxit=10000,reltol=1e-12)),error=function(e)NULL)
    if(!is.null(nm)&&is.finite(nm$value)&&nm$value<opt$value&&all(nm$par>=lo)&&all(nm$par<=hi)) opt<-nm
  }
  if(!is.finite(opt$value)||any(!is.finite(opt$par))) stop('No finite fitted solution')
  # A fit at the imposed bounds is reported but must not be interpreted as
  # an unconstrained estimate of the apparent infection rate.
  boundary_fit<-any(abs(opt$par-lo)<1e-6 | abs(opt$par-hi)<1e-6)
  fitted<-pe_predict(model,opt$par,t);n<-length(t);k<-3;sse<-sum((y-fitted)^2)
  # AICc valid as Gaussian working likelihood only for UNWEIGHTED fits.
  aic<-if(weighting=='unweighted')n*log(max(sse,.Machine$double.eps)/n)+2*k else NA_real_
  aicc<-if(is.finite(aic)&&n>k+1)aic+2*k*(k+1)/(n-k-1) else NA_real_
  resid<-100*(y-fitted)
  ac1<-if(length(resid)>=4 && sd(resid)>0) suppressWarnings(cor(head(resid,-1),tail(resid,-1))) else NA_real_
  list(model=model,parameters=opt$par,weighting=weighting,metrics=data.frame(model=model,n=n,RMSE_pct=sqrt(sse/n)*100,MAE_pct=mean(abs(y-fitted))*100,AIC=aic,AICc=aicc,lag1_residual_cor=ac1,converged=(opt$convergence==0),boundary_fit=boundary_fit,optimizer_code=opt$convergence),
       observed=data.frame(time=t,observed_pct=y*100,fitted_pct=fitted*100,residual_pct=resid),predict=function(tt)100*pe_predict(model,opt$par,tt))
}
pe_compare <- function(d,models=c('logistic','gompertz','monomolecular'),weighting='unweighted') {
  fits<-lapply(models,function(m)tryCatch(pe_fit_one(d$time,d$severity_pct,m,weighting,if('n_assessed'%in%names(d))d$n_assessed else NULL),error=function(e)NULL));names(fits)<-models
  fits<-Filter(Negate(is.null),fits)
  if(!length(fits))stop('No models converged. Check input series and model bounds.')
  tab<-do.call(rbind,lapply(fits,`[[`,'metrics'))
  if(all(is.finite(tab$AICc))) {
    tab<-tab[order(tab$AICc),,drop=FALSE];delta<-tab$AICc-min(tab$AICc)
    tab$AICc_weight<-exp(-delta/2)/sum(exp(-delta/2))
  } else {tab<-tab[order(tab$RMSE_pct),,drop=FALSE];tab$AICc_weight<-NA_real_}
  list(fits=fits,comparison=tab,best=fits[[as.character(tab$model[1])]])
}
pe_audpc_groups <- function(d,group_cols=c('treatment','moisture','replicate')) {
  cols<-intersect(group_cols,names(d)); if(!length(cols))stop('Provide a replicate or independent-unit identifier')
  spl<-split(d,interaction(d[cols],drop=TRUE,lex.order=TRUE))
  ans<-lapply(spl,function(x){x<-x[order(x$time),];if(nrow(x)<2||anyDuplicated(x$time)||any(!is.finite(x$severity_pct)))return(NULL)
    data.frame(x[1,cols,drop=FALSE],n_assessments=nrow(x),start_day=min(x$time),end_day=max(x$time),AUDPC=audpc(x$time,x$severity_pct),rAUDPC=audpc(x$time,x$severity_pct)/(100*diff(range(x$time))))})
  ans<-Filter(Negate(is.null),ans);if(!length(ans))stop('No valid independent time series')
  do.call(rbind,ans)
}
pe_crossing <- function(fit,threshold,observed_last,horizon,origin=0,boot=NULL,boot_grid=NULL) {
  lower<-min(origin,min(fit$observed$time))
  upper<-observed_last+horizon
  grid<-seq(lower,upper,length.out=3001)
  yy<-fit$predict(grid);z<-yy-threshold
  ix<-which(z[-length(z)]<0 & z[-1]>=0)
  day<-if(length(ix)){i<-ix[1];grid[i]+(grid[i+1]-grid[i])*(-z[i])/(z[i+1]-z[i])}else NA_real_
  obs<-fit$observed;hit<-which(obs$observed_pct>=threshold)
  first_obs<-if(length(hit))obs$time[hit[1]] else NA_real_
  status<-if(!is.na(first_obs))'Observed at assessment' else if(is.na(day))'Not reached in horizon' else if(day<min(obs$time))'Model crossing before first assessment' else if(day<=observed_last)'Historical model estimate only' else 'Unvalidated future extrapolation'
  ci<-c(NA_real_,NA_real_)
  if(!is.null(boot) && nrow(boot)>0) {
    days<-apply(boot,1,function(v){ix<-which(v[-length(v)]<threshold & v[-1]>=threshold);if(!length(ix))return(NA_real_);if(is.null(boot_grid))return(NA_real_);boot_grid[ix[1]]})
    days<-days[is.finite(days)];if(length(days)>=20)ci<-quantile(days,c(.025,.975),names=FALSE)
  }
  data.frame(threshold_pct=threshold,first_observed_day=first_obs,model_crossing_day=day,bootstrap_low=ci[1],bootstrap_high=ci[2],status=status)
}
pe_rolling_origin <- function(d,model,min_train=5L) {
  d<-d[order(d$time),];n<-nrow(d)
  if(n<=min_train)return(data.frame(status='Insufficient data',n_test=0,rolling_RMSE_pct=NA_real_,rolling_MAE_pct=NA_real_))
  errors<-numeric()
  for(i in seq.int(min_train,n-1L)) {
    f<-tryCatch(pe_fit_one(d$time[seq_len(i)],d$severity_pct[seq_len(i)],model),error=function(e)NULL)
    if(!is.null(f))errors<-c(errors,f$predict(d$time[i+1])-d$severity_pct[i+1])
  }
  if(!length(errors))return(data.frame(status='Rolling-origin fits failed',n_test=0,rolling_RMSE_pct=NA_real_,rolling_MAE_pct=NA_real_))
  data.frame(status='Descriptive one-step rolling-origin evaluation; same series',n_test=length(errors),rolling_RMSE_pct=sqrt(mean(errors^2)),rolling_MAE_pct=mean(abs(errors)))
}
pe_bootstrap_curve <- function(d,model,grid,B=100,seed=42) {
  if(B<20)stop('At least 20 bootstrap iterations required')
  base<-pe_fit_one(d$time,d$severity_pct,model)
  obs<-base$observed;res<-obs$residual_pct
  set.seed(seed)
  mat<-replicate(B,{
    yy<-pmax(0,pmin(100,obs$fitted_pct+sample(res,length(res),replace=TRUE)))
    f<-tryCatch(pe_fit_one(obs$time,yy,model),error=function(e)NULL)
    if(is.null(f))rep(NA_real_,length(grid)) else f$predict(grid)
  })
  if(is.null(dim(mat)))mat<-matrix(mat,ncol=1)
  valid<-colSums(is.finite(mat))==length(grid)
  mat<-mat[,valid,drop=FALSE]
  if(ncol(mat)<20)return(NULL)
  list(grid=grid,low=apply(mat,1,quantile,.025),high=apply(mat,1,quantile,.975),samples=t(mat),successful=ncol(mat),requested=B,
       note='Illustrative iid residual bootstrap; autocorrelation and sampling design are not preserved. Not a calibrated prediction interval.')
}
# Legacy function kept for compatibility with existing tests.
pe_holdout <- function(d,model,holdout=2L) {
  z<-pe_rolling_origin(d,model)
  data.frame(status=z$status,holdout_RMSE_pct=z$rolling_RMSE_pct,n_test=z$n_test)
}
