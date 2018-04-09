#PS10

#install.packages(c("rpart","e1071","kknn","nnet"))
library(mlr)
library(ParamHelpers)
library(rpart)
library(e1071)
library(kknn)
library(nnet)

set.seed(100)

income <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data")
names(income) <- c("age","workclass","fnlwgt","education","education.num","marital.status","occupation",
                   "relationship","race","sex","capital.gain","capital.loss","hours",
                   "native.country","high.earner")
income$native.country <- NULL
income$fnlwgt         <- NULL
# Make sure continuous variables are coded as such
income$age            <- as.numeric(income$age)
income$hours          <- as.numeric(income$hours)
income$education.num  <- as.numeric(income$education.num)
income$capital.gain   <- as.numeric(income$capital.gain)
income$capital.loss   <- as.numeric(income$capital.loss)
# Combine levels of categorical variables that currently have too many levels
levels(income$education) <- list(Advanced = c("Masters,","Doctorate,","Prof-school,"), Bachelors = c("Bachelors,"), "Some-college" = c("Some-college,","Assoc-acdm,","Assoc-voc,"), "HS-grad" = c("HS-grad,","12th,"), "HS-drop" = c("11th,","9th,","7th-8th,","1st-4th,","10th,","5th-6th,","Preschool,"))
levels(income$marital.status) <- list(Married = c("Married-civ-spouse,","Married-spouse-absent,","Married-AF-spouse,"), Divorced = c("Divorced,","Separated,"), Widowed = c("Widowed,"), "Never-married" = c("Never-married,"))
levels(income$race) <- list(White = c("White,"), Black = c("Black,"), Asian = c("Asian-Pac-Islander,"), Other = c("Other,","Amer-Indian-Eskimo,"))
levels(income$workclass) <- list(Private = c("Private,"), "Self-emp" = c("Self-emp-not-inc,","Self-emp-inc,"), Gov = c("Federal-gov,","Local-gov,","State-gov,"), Other = c("Without-pay,","Never-worked,","?,"))
levels(income$occupation) <- list("Blue-collar" = c("?,","Craft-repair,","Farming-fishing,","Handlers-cleaners,","Machine-op-inspct,","Transport-moving,"), "White-collar" = c("Adm-clerical,","Exec-managerial,","Prof-specialty,","Sales,","Tech-support,"), Services = c("Armed-Forces,","Other-service,","Priv-house-serv,","Protective-serv,"))

# Break up the data:
n <- nrow(income)
train <- sample(n, size = .8*n)
test  <- setdiff(1:n, train)
income.train <- income[train,]
income.test  <- income[test, ]



#######################################################
#######################################################


#Part 5 

#######################
#Defining the Task
#######################
theTask <- makeClassifTask(id = "taskname", data = income.train, target = "high.earner")

#################################
# tell mlr what prediction algorithm we'll be using 
##################################
#TREE
pred.Tree <- makeLearner("classif.rpart", predict.type = "response")
#Logistic Regression 
pred.Logic <- makeLearner("classif.glmnet", predict.type = "response")
#Neural Network
pred.Neural <- makeLearner("classif.nnet", predict.type = "response")
#Naive Bayes 
pred.Bayes <- makeLearner("classif.naiveBayes", predict.type = "response")
#KKNN
pred.KKNN <- makeLearner("classif.kknn", predict.type = "response")
#SVM
pred.SVM <- makeLearner("classif.svm", predict.type = "response")


##################################
# Set resampling strategy (here let's do 3-fold CV)
resampleStrat <- makeResampleDesc(method = "CV", iters = 3)
##################################


#################################
# Take 10 random guess tuning strat 
tuneMethod <- makeTuneControlRandom(maxit = 10L)
################################

########################################################
########################################################
########################################################
########################################################


#Part 6 
#Setting up the parameters 
#TREE 

parm_tree<- makeParamSet(
  makeIntegerParam("minsplit",lower = 10, upper = 50), 
  makeIntegerParam("minbucket", lower = 5, upper = 50), 
  makeNumericParam("cp", lower = 0.001, upper = 0.2)) 

#Logistic Regression 
parm_regression <- makeParamSet(makeNumericParam("lambda",lower=0,upper=3),
                                makeNumericParam("alpha",lower=0,upper=1))

#Nueral Network
parm_Nueral<- makeParamSet(makeIntegerParam("size", lower = 1,upper = 10),
                           makeNumericParam("decay",lower = 0.1,upper = 0.5),
                           makeIntegerParam("maxit",lower = 1000,upper = 1000))
#kNN
parm_KKNN<-makeParamSet(makeIntegerParam("k", lower = 1,upper = 30))

#SVM
parm_SVM<- makeParamSet(makeDiscreteParam("cost", values = 2^c(-2,-1, 0, 1, 2, 10)),
            makeDiscreteParam("gamma", values = 2^c(-2,-1, 0, 1, 2, 10)))

               
              
               
               
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################

               
#Part 7                
          
               
# Do the tuning

#Tree model with F1 score 
tunedModel_tree <- tuneParams(learner = pred.Tree,
                         task = theTask,
                         resampling = resampleStrat,
                         measures =list(f1,gmean),
                         par.set = parm_tree,
                         control = tuneMethod,
                         show.info = TRUE)



#Logistic Regression 
tunedModel_Logic<- tuneParams(learner = pred.Logic,
                              task = theTask,
                              resampling = resampleStrat,
                              measures = list(f1,gmean),      
                              par.set = parm_regression,
                             control = tuneMethod,
                             show.info = TRUE)


#Neural Network 

tunedModel_Neural<-tuneParams(learner = pred.Neural,
                                 task = theTask,
                                 resampling = resampleStrat,
                                 measures = list(f1,gmean),      
                                 par.set = parm_Nueral,
                                 control = tuneMethod,
                                 show.info = TRUE)



#KKNN 
tunedModel_KKNN<-tuneParams(learner = pred.KKNN,
                               task = theTask,
                               resampling = resampleStrat,
                               measures = list(f1,gmean),      
                               par.set = parm_KKNN,
                               control = tuneMethod,
                               show.info = TRUE)



#SVM
tunedModel_SVM<-tuneParams(learner = pred.SVM,
                              task = theTask,
                              resampling = resampleStrat,
                              measures = list(f1,gmean),      
                              par.set = parm_SVM,
                              control = tuneMethod,
                              show.info = TRUE)




########################################################
########################################################
########################################################
########################################################
########################################################
########################################################

#Training and predicting 


#Applying the optimal tuning parameter to each algorith


pred.Tree<-setHyperPars(learner = pred.Tree,par.vals = tunedModel_tree$x)
pred.Logic<-setHyperPars(learner = pred.Logic,par.vals = tunedModel_Logic$x)
pred.Neural<-setHyperPars(learner = pred.Neural,par.vals = tunedModel_Neural$x)
pred.KKNN<-setHyperPars(learner = pred.KKNN,par.vals = tunedModel_KKNN$x)
pred.SVM<-setHyperPars(learner = pred.SVM,par.vals = tunedModel_SVM$x)

# Verify performance on cross validated sample sets
performance.Tree<-resample(pred.Tree,theTask,resampleStrat,measures=list(f1,gmean))
performance.Logit<-resample(pred.Logic,theTask,resampleStrat,measures=list(f1,gmean))
performance.Neural<-resample(pred.Neural,theTask,resampleStrat,measures=list(f1,gmean))
performance.KKNN<-resample(pred.KKNN,theTask,resampleStrat,measures=list(f1,gmean))
performance.SVM<-resample(pred.SVM,theTask,resampleStrat,measures=list(f1,gmean))
performance.Bayes<-resample(pred.Bayes,theTask,resampleStrat,measures = list(f1,gmean))
performance.Tree
performance.Logit
performance.Neural
performance.KKNN
performance.SVM
performance.Bayes
# Train the final model
finalModel.Tree <- train(learner = pred.Tree, task = theTask)
finalModel.Logic<-train(learner=pred.Logic,task=theTask)
finalModel.Neural<-train(learner=pred.Neural,task=theTask)
finalModel.KKNN<-train(learner=pred.KKNN,task=theTask)
finalModel.SVM<-train(learner=pred.SVM,task=theTask)
finalModel.Bayes<-train(learner=pred.Bayes,task=theTask)
# Predict in test set!
prediction.tree <- predict(finalModel.Tree, newdata = income.test)
prediction.Logic<-predict(finalModel.Logic,newdata=income.test)
prediction.Neural<-predict(finalModel.Neural,newdata=income.test)
prediction.KKNN<-predict(finalModel.KKNN,newdata=income.test)
prediction.SVM<-predict(finalModel.SVM,newdata=income.test)
prediction.Bayes<-predict(finalModel.Bayes,newdata=income.test)
prediction.tree
prediction.Logic
prediction.Neural
prediction.KKNN
prediction.SVM
prediction.Bayes


#out of sample performance 
performance(prediction.tree, measures = list(f1, gmean))
performance(prediction.Logic, measures = list(f1, gmean))
performance(prediction.Neural, measures = list(f1, gmean))
performance(prediction.KKNN, measures = list(f1, gmean))
performance(prediction.SVM, measures = list(f1, gmean))
performance(prediction.Bayes, measures = list(f1, gmean))

