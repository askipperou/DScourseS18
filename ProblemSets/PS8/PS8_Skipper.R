
library(nloptr)
library(stargazer)
#install.packages("numDeriv")
#Part 4 
#4.1 Setting seed of the random generator 
set.seed(100)
#4.2 X martix following a normally distributed and 1st column is 1 
N<-100000
K<-10
sigma<-.5

X <- matrix(rnorm(N*K, mean = 0, sd=1),N,K)
X[,1]<-1

#4.3 creating epsilon 
eps<-rnorm(N, mean=0, sd=sigma) 
#4.4 creating beta 
beta <-c(1.5,-1,-0.25,0.75,3.5,-2,0.5,1,1.25,2)
#4.5 genrating y which is a vector equal to xbeta+eps 
Y<-(X%*%beta+eps)
head(Y)






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#Part 5 

bols<-solve(t(X)%*%X)%*%t(X)%*%Y
head(bols)
stargazer(head(bols))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Part 6
# set up a stepsize
alpha <- 0.0000003
# set up a number of iteration
iter <- 500
#objective function 
obj<-function(beta,Y,X){return(sum((y-X%*%beta)^2))}
#defining gradient funciton 
gradient<-function(beta,Y,X) {return ( as.vector(-2*t(X)%*%(Y-X%*%beta)) )
}
#initial values 
beta1<-runif(dim(X)[2])
#initalizin a vlaue of random to beta 
set.seed(100)
#creating a vector to contain all beta's 
beta.all<-matrix("numeric",length(beta),iter)
# gradient descent method to find the minimum
iter1<- 1
beta0 <- 0*beta
while (norm(as.matrix(beta0)-as.matrix(beta))>1e-8) {
  beta0 <- beta
  beta <- beta0 - stepsize*gradient(beta0,Y,X)
  beta.All[,iter1] <- beta
  if (iter1%%10000==0) {
    print(beta)
  }
  iter1 <- iter1+1
}
# print result and plot all xs for every iteration
print(iter1)
print(paste("The minimum of f(beta,y,X) is ", beta, sep = ""))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Part 7 
library(nloptr)
# Our objective function
objf <- function(beta,Y,X) {
  return (sum((Y-X%*%beta)^2))
}
# Gradient objective function
gradient1 <- function(beta,Y,X) {
  return ( as.vector(-2*t(X)%*%(Y-X%*%beta)) )
}
# initial values
#start at  random uniform distirbution 
beta01<- runif(dim(X)[2]) 
## Algorithm parameters
options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e3)
# Optimize
result <- nloptr( x0=beta01,eval_f=objf,eval_grad_f=gradient1,opts=options,Y=Y,X=X)
print(result)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Part 8 
library(nloptr)
#objective function
o <- function(theta,Y,X) {
  grad <- as.vector(rep(0,length(theta)))
  beta11 <- theta[1:(length(theta)-1)]
  sig <- theta[length(theta)]
  grad[1:(length(theta)-1)] <- -t(X)%*%(Y - X%*%beta11)/(sig^2) 
  grad[length(theta)] <- dim(X)[1]/sig - crossprod(Y-X%*%beta11)/(sig^3)
  return (grad)
  }

# initial values
# uniform random numbers equal to number of coefficients
theta0<- runif(dim(X)[2]+1) 

## Algorithm parameters
options1<- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-6,"maxeval"=1e4)

## Optimize!
result1 <- nloptr( x0=theta0,eval_f=o,opts=options1,Y=Y,X=X)
print(result)
betahat  <- result$solution[1:(length(result$solution)-1)]
sigmahat <- result$solution[length(result$solution)]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Part 9 

a<-lm(Y~X -1)
summary(a)
stargazer(a)








