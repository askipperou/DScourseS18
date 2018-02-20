#installing packages install.packages("rvest") 
#install.packages("dplyr")

#Download packages 
library(xml2)
library(rvest)
library(dplyr)

#Reading the html code to work in R 
foursq<-read_html("https://foursquare.com/explore?cat=drinks&mode=url&near=Norman%2C%20OK%2C%20United%20States&nearGeoId=72057594042471698")

#creating a value to store the selected scrapped data from the html 
results<- foursq %>% html_nodes(".venueDetails > div :nth-child(1)") %>% html_text()

rating<- foursq %>% html_nodes(".venueScore") %>% html_text()
print(rating) 

name<- foursq %>% html_nodes(".venueName a") %>% html_text()
print(name) 

#money<- foursq %>% html_nodes(".darken") %>% html_text()
#print(money)

dataframe<- data.frame(name, rating)
print(dataframe)

#-----------

#PART 2 API

#installing packages
#install.packages("Quandl")

#library
library(Quandl)

mydata<-Quandl("FRED/UNRATE")
mydata  
