source('models.R');source('spatial_models.R')
stopifnot(abs(audpc(c(0,5,10,15,20),c(5,12,25,40,60))-547.5)<1e-10)
stopifnot(abs(index_dispersion(c(2,3,3,8,9))$D-2.1)<1e-10)
stopifnot(ordinary_runs(c(1,1,0,0,1,0,1,1,0))$runs==6)
for(m in c('exponential','monomolecular','logistic','gompertz','linear'))stopifnot(abs(phyto_curve(0,.05,.12,m)-.05)<1e-10)
stopifnot(abs(sum(phyto_distributions(0:10,'beta_binomial',n=10,alpha=2,beta=5))-1)<1e-10)
stopifnot(nrow(network_metrics(as.matrix(read.csv('examples/network.csv',header=FALSE))))==4)
cat('All integrated function checks passed.\n')

# Additional corrected reference calculations
stopifnot(abs(dispersion(c(2,3,3,8,9))-2.1)<1e-12)
stopifnot(abs(clark_evans(c(0,2),c(0,0),area=4)$R-2*sqrt(2))<1e-12)
stopifnot(abs(audpc(c(0,5,10,15,20),c(5,12,25,40,60))/(100*20)-0.27375)<1e-12)
