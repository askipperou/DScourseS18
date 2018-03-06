#Visualization 1 
#uploaind data from kaggle https://www.kaggle.com/START-UMD/gtd
library(readr)
globalterrorismdb_0617dist <- read_csv("~/Downloads/globalterrorismdb_0617dist.csv")
View(globalterrorismdb_0617dist)

#Seperating into a data frame 
group<-as.data.frame(globalterrorismdb_0617dist)
R1<-subset(group, region=='1' )
#R2<-subset(group, region=='2' )
#R3<-subset(group, region=='3' )
#R4<-subset(group, region=='4' )
#R5<-subset(group, region=='5' )
#R6<-subset(group, region=='6' )
#R7<-subset(group, region=='7' )
#R8<-subset(group, region=='8' )
#R9<-subset(group, region=='9' )
#R10<-subset(group, region=='10' )
#R11<-subset(group, region=='11' )
#R12<-subset(group, region=='12' )



#All the packages needed
library(ggplot2)
library(highcharter)
library(tidyr)
library(scales)
library(dplyr)


#Pulling region 1 data year and country R1 = North AMerica
R1country<-c(R1$country_txt)
R1Y<-c(R1$iyear)
R1Y_C<-as.data.frame(cbind(R1country,R1Y)) #combing both data frames 
summary(R1Y_C)
#renaming the column 
colnames(R1Y_C)<-c("Country","Year")
summary(R1Y_C)
R1Y_C<-table(R1Y_C) #forming a tbale to show the freq
R1Y_C<-as.data.frame(R1Y_C) #making it a data frame 


#ploting 
quartz()
ggplot(data = R1Y_C, aes(x=Year, y=Freq, fill=Country))+
  geom_bar(stat="identity")+ theme(axis.text.x = element_text(angle = 90))+
  ggtitle("Terrorist Incidents in North America")
#--------------------------






#visualization 2 

library(quantmod)
getSymbols("AAPL", src="yahoo",from="1995-01-01")
getSymbols("MSFT", src = "yahoo",from="1995-01-01")
#creating a data frame with stock closing prices
Stocks<-as.data.frame(merge(AAPL$AAPL.Close,MSFT$MSFT.Close))
head(Stocks)
colnames(Stocks)<-c("AAPL","MSFT")
#storing the daily returns ot find the correlation
#use diff calucates lag difference by one day and as.matrix to do on all the columns
stock_returns<-data.frame(diff(as.matrix(log(Stocks))))
head(stock_returns)
cor(stock_returns)
cov(stock_returns)

plot(stock_returns)
quartz()

ggplot(data=stock_returns,aes(x=AAPL,y=MSFT))+geom_point()+
  ggtitle("Correlation Between AAPL and MSFT")


A<-yearlyReturn(AAPL)
M<-yearlyReturn(MSFT)
quartz()
plot(A)
plot(M)
AM<-merge(M,A)
colnames(AM)<-c("Micrsoft_Yearly_Returns","Apple_Yearly_Returns")
quartz()
plot(AM, main="Yearly Apple & Microsoft Stock Returns", xlab="Year", ylab="Return" )
legend('topright',names(AM),lty=1,col = c('red','black'),cex = .5)
#How to change an id col into and actual col from data frames
#library(reshape2)
#setDT(data, keep.rownames = T)












#####------------------------
#visualization 3 

all<-as.data.frame(group$iyear,group$region_txt)
colnames(all)<-c("Year")
all<-table(all)
all<-as.data.frame(all)
colnames(all)<-c("Year","Freqency")
quartz()
ggplot(data=all, aes(x=Year,y=Freqency, fill=Freqency))+geom_bar(stat="identity",fill = "#FF6666")+
  theme(axis.text.x=element_text(angle=90))+ ggtitle("Terrorist Incidents Frequency Around The Globe")

