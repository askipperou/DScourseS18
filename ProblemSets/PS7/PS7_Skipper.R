
#PS7 

#Part 3: Installing the packages
#install.packages("MixedDataImpute")
#install.packages("mice")
#install.packages("stargazer")

library(MixedDataImpute)
library(mice)
library(stargazer)
library(dplyr)
library(readr)
#install.packages("imputeR")
library(imputeR)
wages <- read_csv("~/Documents/GitHub/DScourseS18/Modeling/wages.csv")


#Part 5: Dropping observations where either hgc or tenure are missing

#checking the missing values 
colSums(is.na(wages))

wages<-wages[!is.na(wages$hgc),]
wages<-wages[!is.na(wages$tenure),]

#making sure the NA's in hgc and tenure are gone 
colSums(is.na(wages))


#Part 6: Producing a summary table of df wages
#findig the rate at which logs are missing 
sum(is.na(wages$logwage))/2229
stargazer(wages)


#Part 7 

#7.1 Estimating the regression using only complete cases
#Assuming MCAR missing complete at random 
complete.cases(wages$logwage)
sum(is.na(wages$logwage))
m<-lm(logwage~. , data = wages)
stargazer(m,type = "latex")

#7.2 & 7.3 mean imputation to fill in missing log wages impute missing log wages as thier predicted 
#values from the complete cases regression above 
wages$logwage<-guess(wages$logwage, type="mean")

m1<-lm(logwage~. , data = wages)

stargazer(m1,type = "latex")


#7.4 using the mice package to perfomr a multiple imputation regresion
mice_wage<-mice(wages, seed = 12345)
summary(mice_wage)
fit<-with(mice_wage, lm(logwage~ hgc+college+tenure+tenure^2+age+married))
round(summary(pool(fit)))
stargazer(m,m1)

