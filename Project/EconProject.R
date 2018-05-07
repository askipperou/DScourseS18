#Packages
#library(readr)
#library(stargazer)
#library(lmtest)
#library(car)

#Importing the year 2000
#RealEconExcel2000 <- read_csv("~/Documents/Classes/Econ Metric/RealEconExcel2000.csv")


#Importing the year 2010
#RealEconExcel2010 <- read_csv("~/Documents/Classes/Econ Metric/RealEconExcel2010.csv")


#Linear Reggression for 2000

R2<-lm(x ~ x1+x2+x3+x4+x5+x6+x7+x8, data=RealEconExcel2000)
R2
summary(R2)


#Checking the models prediction 
NREE2000<-RealEconExcel2000[-1,]
R20<-lm(x ~ x1+x2+x3+x4+x5+x6+x7+x8, data=NREE2000)
529.7-predict(R20,newdata = data.frame(x1=162.6,x2=0.895400,x3=4.89466,x4=6.3,x5=1745.9,x6=12.1,x7=114,x8=24.27534))
predict(R20,newdata = data.frame(x1=162.6,x2=0.895400,x3=4.89466,x4=6.3,x5=1745.9,x6=12.1,x7=114,x8=24.27534))

##################################
#################################

#Linear Regression for 2010
R21<-lm(x0 ~ x11+x21+x31+x41+x51+x61+x71+x81, data=RealEconExcel2010)
(summary(R21))

#checking the models prediction 
NREE2010<-RealEconExcel2010[-1,]
R211<-lm(x0 ~ x11+x21+x31+x41+x51+x61+x71+x81, data=NREE2010)
518.7-predict(R211,newdata = data.frame(x11=132.5,x21=0.9188154,x31=5.56894,x41=5.2,x51=5324.5,x61=13.90000,x71=135,x81=26.596453))
predict(R211,newdata = data.frame(x11=132.5,x21=0.9188154,x31=5.56894,x41=5.2,x51=5324.5,x61=13.90000,x71=135,x81=26.596453))

##################################
#################################


#Linear Regression on 2000 with siginificant variables 
R23<-lm(x~x2,data = RealEconExcel2000)
R23
summary(R23)
#checking the preditions
R231<-lm(x~x2,data = NREE2000)
529.7-predict(R231,newdata = data.frame(x2=0.895400))
predict(R231,newdata = data.frame(x2=0.895400))

#Linear Regression on 2010 with significant variables 
R24<-lm(x0~x21,data = RealEconExcel2010)
R24
#chekcing the prediction 
R241<-lm(x0~x21,data = NREE2010)
518.7-predict(R241,newdata = data.frame(x21=0.9188154))
predict(R241,newdata = data.frame(x21=0.9188154))

summary(R24)
##########################################################################################################
#####################################  2000   ############################################################
#####################################  2000   ############################################################
##########################################################################################################




#######################################
#Correlation for 2000 variables########
#######################################
R_2000<-RealEconExcel2000[,2:length(RealEconExcel2000)]

cor(R_2000)
pairs(R_2000, main = "Year 2000")


#######################
##Hetero for 2000######
#######################



par(mfrow=c(2,2)) # init 4 charts in 1 panel
plot(R2)
bptest(R2)

#####Reduced Model#######
bptest(R23)

##########################
#multicolinearity for 2000
##########################
vif(R2)

##########################################################################################################
################################   2010        ###########################################################
################################   2010        ###########################################################
##########################################################################################################





#######################################
#Correlation for 2010 variables########
#######################################
R_2010<-RealEconExcel2010[,2:length(RealEconExcel2010)]

cor(R_2010)
pairs(R_2010, main="Year 2010")





##########################
#multicolinearity for 2010
##########################

vif(R21)
##########################
##Hetero plot for 2010####
##########################


plot(R21)
bptest(R21)

#####Reduced Model#######
bptest(R24)

##########################################################################################################
##########################################################################################################
##########################################################################################################
##########################################################################################################




##################################
######  LATEX CODE ###############
##################################


#Tables for Latex

stargazer(R2,type = "latex", title="Year 2000 Regression",column.sep.width = "1pt", no.space = T,single.row = T)
stargazer(R21, type = "latex",title = "Year 2010 Regression", column.sep.width = "1pt",no.space = T,single.row = T)
stargazer(R23,type = "latex",title = " Reduced Year 2000 Regression", column.sep.width = "1pt",no.space = T,single.row = T)
stargazer(R24,type = "latex",title = " Reduced Year 2010 Regression",column.sep.width = "1pt",no.space = T,single.row = T)
stargazer(vif(R2), type = "latex",title = "Year 2000 VIF")
stargazer(vif(R21),type = "latex",title = "Year 2010 VIF")










