library(rjags)


#Example 7.10 with slight modifications. 
data <- list(y=c(10,9,9,8,9.5,7,12,11,8,10.5))
#INI <- list(list(mu=10,tau=1),list(mu=9, tau=0.1))

#Specifying the JAGS code here. 
mdl <- textConnection("
data {n0 <- 0.1}
model{ 
  for (i in 1:10) {y[i] ~ dnorm(mu,tau)} 
  tau ~ dgamma(1,0.01)
  sigma2 <- 1/tau 
  mu ~ dnorm(0, n0*tau)
}")

M <- jags.model(mdl,data=data,n.chains=2,n.adapt=500)
R <- coda.samples(M,c("mu","sigma2"),n.iter=25000)

summary(R); traceplot(R)

HPDinterval(R, prob = 0.95)
gelman.diag(R)
gelman.plot(R)
dic.samples(M, n.iter=1000, type="pD")
