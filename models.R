# PhytoEpiQuant Phase I: reproducible reference functions
phyto_curve <- function(time, y0, r, model=c('exponential','monomolecular','logistic','gompertz','linear'), slope=NULL) {
 model <- match.arg(model); stopifnot(all(time>=0),y0>0,y0<1,r>=0)
 switch(model, exponential=pmin(1,y0*exp(r*time)), monomolecular=1-(1-y0)*exp(-r*time),
 logistic=plogis(qlogis(y0)+r*time), gompertz=exp(log(y0)*exp(-r*time)),
 linear=y0+if(is.null(slope)) r*time else slope*time)
}
audpc <- function(time, disease) {
 stopifnot(length(time)==length(disease),length(time)>=2,all(is.finite(time)),all(is.finite(disease)),all(diff(time)>0))
 sum(diff(time)*(head(disease,-1)+tail(disease,-1))/2)
}
dispersion <- function(counts) {
 stopifnot(length(counts)>1,all(is.finite(counts)),all(counts>=0))
 if(mean(counts)==0) return(NA_real_)
 var(counts)/mean(counts)
}
phyto_distributions <- function(x, distribution=c('normal','poisson','binomial','exponential','beta','beta_binomial'),...) {
 distribution<-match.arg(distribution); a<-list(...)
 switch(distribution, normal=dnorm(x,mean=a$mu,sd=a$sigma),poisson=dpois(x,a$lambda),
 binomial=dbinom(x,size=a$n,prob=a$p),exponential=dexp(x,rate=a$lambda),
 beta=dbeta(x,shape1=a$alpha,shape2=a$beta),
 beta_binomial={n<-a$n;alpha<-a$alpha;beta<-a$beta;exp(lchoose(n,x)+lbeta(x+alpha,n-x+beta)-lbeta(alpha,beta))})
}
# Validation checks are in tests/test_models.R (not run during app startup).
