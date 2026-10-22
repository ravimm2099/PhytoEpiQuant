# Download and export published R-package data, without inventing observations.
packages <- c("epifitter", "r4pde")
for (pkg in packages) if (!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
dir.create("published_examples", showWarnings=FALSE)
data("PowderyMildew", package="epifitter", envir=environment())
write.csv(PowderyMildew, "published_examples/epifitter_PowderyMildew_original.csv", row.names=FALSE)
print(names(PowderyMildew))
print(utils::data(package="r4pde")$results[,"Item"])
# Simulated example (NOT observed literature data):
set.seed(1)
sim <- epifitter::sim_logistic(N=80,y0=.01,dt=10,r=.12,alpha=.2,n=5)
write.csv(sim,"published_examples/epifitter_simulated_logistic.csv",row.names=FALSE)
