#other way to do it if sparkR is not working right 


#installing for data manipulation 
#install.packages("dplyr")
#library(dplyr)

#creating a data frame
#df1<-as.data.frame(iris)

#creating a sparkdatafram)
#df<-createDataFrame(df1)

#displaying the classes 
#class(df1)
#class(df)

#Showing the first 6 rows 
#head(SparkR::select(df, df$Sepal_Length, df$Species))
#head(SparkR::select(df1, df1$Sepal_Length, df1$Species))

#lenght larger than 5.5 
#head(SparkR::filter(df, df$Sepal-Length>5.5))
#head(SparkR::filter(df1, df1$Sepal-Length>5.5))

#combiningg select and filter 
#df %>% SparkR::select(df$Sepal_Length, df$Species) %>% SparkR::filter(df$Sepal_Length>5.5) %>% head

#combining summarize and groupBy 

#------------------------------------------------------
#creating a data frame 
df1<-as.data.frame(iris)

#creating a sparkdataframe 
df<-createDataFrame(df1)

#Displaying the classes 
class(df1)
class(df)

#Showing the first 6 rows
head(select(df, df$Sepal_Length, df$Species))
head(select(df1, df1$Sepal_Length, df1$Species))

#lenght larger than 5.5
head(filter(df, df$Sepal-Length>5.5))
head(filter(df1, df1$Sepal-Length>5.5))

#Group by and summarizing 
head(summarize(groupBy(df, df$Species), mean=mean(df$Sepal_Length), count=n(df$Sepal_Length)))

#RRD operation is to sort with arrange 
df2<-head(summarize(groupBy(df, df$Species), mean=mean(df$Sepal_Length), count=n(df$Sepal_Length)))
head(arrange(df2, asc(df2$Species)))
