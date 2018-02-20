#Do not run like intended when using  script but works 
#individualy in R 
#installing packages
#install.packages("Quandl")
#install.packages("xts")


#library
library(Quandl)
#library(xts)

mydata<-Quandl("FRED/UNRATE")
mydata


