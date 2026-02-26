options(scipen=999)
setwd("~/Documents/HH/WISE21_22/Selected Topics in Economics/Paper/Lisa_Fadelli_Paper")
library(readxl)
#upload the dataset
dataset<- read_excel("HDIGlobalizationDataset.xlsx", sheet = "Dataset3")
library(plm)
library(sandwich)
library(stargazer)
library(lmtest)
library(xtable)

#Declare dataset to be a panel dataset
panel_data <- pdata.frame(dataset, index=c("Country", "Year"))

#If time observations are consecutive
is.pconsecutive(panel_data)
#If panel dataset is balanced or unbalanced
is.pbalanced(panel_data)


#Check for multicollinearity problem
dataset2<- read_excel("HDIGlobalizationDataset copy.xlsx")
cor_matrix<-cor(dataset2)
round(cor_matrix,2)
stargazer(cor_matrix, type="latex", out="CorrelationMatrix.tex", title="Correlation Matrix")
#Summary Statistics
library(vtable)
summarystatistics <- summary(panel_data2)
st(panel_data, vars = c('HDI', 'KOF', 'KOFE', 'KOFS', 'KOFP', 'FDI', 'TradeOpenness', 
                        'State.Fragility', 'Population.Growth','Birth.Rate', 'Death.Rate'),
   title = "Summary Statistics", out = "latex")
stargazer(summarystatistics, type = 'latex', title = 'Summary Statistics', out = "SummaryStatistics.tex")


pdim(panel_data) #to inspect the individual and time dimensions of dataset
head(index(panel_data)) #to extract the index attribute

####################################################################################################
#FIRST SPECIFICATION

#POOLED OLS REGRESSION
model1_pool <- plm(HDI ~ KOF+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                   data=panel_data, model="pooling")
summary(model1_pool)

#FIXED EFFECTS MODEL WITH INDIVIDUAL EFFECTS
model1_fe <- plm(HDI ~ KOF+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                 data=panel_data, model="within")
summary(model1_fe)

#Individual effects First Specification
fixef(model1_fe)
summary(fixef(model1_fe))[ , c("Estimate", "Pr(>|t|)")] 

#Test the joint significance of the fixed individual effects
pFtest(model1_fe, model1_pool) # Null rejected

#FIXED EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model1_tw_fe <- plm(HDI ~ KOF+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways" ,data=panel_data, model="within")
summary(model1_tw_fe)

#Test the joint significance of the fixed individual and time effects
pFtest(model1_tw_fe, model1_pool) # Null rejected
#Test the joint significance of the fixed time effects
pFtest(model1_tw_fe, model1_fe) # Null Rejected

#Breusch Pegan Test twoways effects for balanced panels 
plmtest(model1_tw_fe, effect="twoways", type="honda")

#RANDOM EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model1_tw_re <- plm(HDI ~ KOF+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways", data=panel_data, model="random")
summary(model1_tw_re)

#Hausman-test - Compare two-way FE model with two-way RE model
phtest(model1_tw_fe, model1_tw_re) # Null rejected

#ASSUMPTIONS
# No serial correlation Breusch-Godfrey for the idiosyncratic component of the error term
pbgtest(model1_tw_fe) # Null rejected
# Cross-sectional independence 
pcdtest(model1_tw_fe, test=c("lm")) # Null rejected
# Homoskedasticity
bptest(model1_tw_fe) # Null rejected
# Check nonstationarity condition
cipstest(panel_data$HDI, type ="drift") #Nonstationary
cipstest(panel_data$KOF, type = "drift") #Nonstationary
cipstest(panel_data$KOFE, type = "drift") #Nonstationary
cipstest(panel_data$KOFP, type = "drift") #Nonstationary
cipstest(panel_data$KOFS, type = "drift") #Nonstationary
cipstest(panel_data$State.Fragility, type = "drift") #Nonstationary
cipstest(panel_data$TradeOpenness, type = "drift") #Nonstationary
cipstest(panel_data$FDI, type = "drift") #Nonstationary
cipstest(panel_data$Birth.Rate, type = "drift") #Nonstationary
cipstest(panel_data$Death.Rate, type = "drift") #Stationary (pvalue = 0.03123)
cipstest(panel_data$Population.Growth, type = "drift") #Nonstationary

#Transform the variable --> First-Differenced Transformation

####################################################################################################
#SECOND SPECIFICATION
#POOLED OLS REGRESSION
model2_pool <- plm(HDI ~ KOFE+KOFS+KOFP+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                   data=panel_data, model="pooling")
summary(model2_pool)

#FIXED EFFECTS MODEL WITH INDIVIDUAL EFFECTS
model2_fe <- plm(HDI ~ KOFE+KOFS+KOFP+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                 data=panel_data, model="within")
summary(model2_fe)

#Individual effects second specification
fixef(model2_fe)
summary(fixef(model2_fe))[ , c("Estimate", "Pr(>|t|)")] 

#Test the joint significance of the fixed individual effects
pFtest(model2_fe, model2_pool) # Null rejected

#FIXED EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model2_tw_fe <- plm(HDI ~ 1+KOFE+KOFS+KOFP+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways", data=panel_data, model="within")
summary(model2_tw_fe)

#Test the joint significance of the fixed individual and time effects
pFtest(model2_tw_fe, model2_pool) # Null rejected
#Test the joint significance of the fixed time effects
pFtest(model2_tw_fe, model2_fe) # Null rejected

#Breusch Pegan Test twoways effects for balanced panels 
plmtest(model2_tw_fe, effect="twoways", type="honda") # Null rejected

#RANDOM EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model2_tw_re <- plm(HDI ~ KOFE+KOFS+KOFP+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways", data=panel_data, model="random")
summary(model2_tw_re)

#Hausman-test - Compare two-way FE model with two-way RE model
phtest(model2_tw_fe, model2_tw_re) # Null rejected

#ASSUMPTIONS
# No serial correlation Breusch-Godfrey for the idiosyncratic component of the error term
pbgtest(model2_tw_fe) # Null rejected
#No cross sectional dependence
pcdtest(model2_tw_fe, test=c("lm")) # Null rejected
# Homoskedasticity
bptest(model2_tw_fe) # Null rejected
# Check nonstationarity condition --> see First Specification


####################################################################################################
#THIRD SPECIFICATION
#POOLED OLS REGRESSION
model3_pool <- plm(HDI ~ FDI+TradeOpenness+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                   data=panel_data, model="pooling")
summary(model3_pool)

#FIXED EFFECTS MODEL WITH INDIVIDUAL EFFECTS
model3_fe <- plm(HDI ~ FDI+TradeOpenness+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                 data=panel_data, model="within")
summary(model3_fe)

#Individual effects second specification
fixef(model3_fe)
summary(fixef(model3_fe))[ , c("Estimate", "Pr(>|t|)")] 

#Test the joint significance of the fixed individual effects
pFtest(model3_fe, model3_pool) # Null rejected

#FIXED EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model3_tw_fe <- plm(HDI ~ FDI+TradeOpenness+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways", data=panel_data, model="within")
summary(model3_tw_fe)


#Test the joint significance of the fixed individual and time effects
pFtest(model3_tw_fe, model3_pool) # Null rejected
#Test the joint significance of the fixed time effects
pFtest(model3_tw_fe, model3_fe) # Null rejected

#Breusch Pegan Test twoways effects for unbalanced panels
plmtest(model3_tw_fe, effect="twoways", type="kw") # Null rejected

#RANDOM EFFECTS MODEL WITH INDIVIDUAL AND TIME EFFECTS
model3_tw_re <- plm(HDI ~ FDI+TradeOpenness+State.Fragility+Population.Growth+Birth.Rate+Death.Rate, 
                    effect="twoways", data=panel_data, model="random")
summary(model3_tw_re)

#Hausman-test - Compare two-way FE model with two-way RE model
phtest(model3_tw_fe, model3_tw_re) # Null rejected

#ASSUMPTIONS
# No serial correlation Breusch-Godfrey for the idiosyncratic component of the error term
pbgtest(model3_tw_fe) # Null rejected
#No cross sectional dependence
pcdtest(model3_tw_fe, test=c("lm")) # Null rejected
# Homoskedasticity
bptest(model3_tw_fe) # Null rejected

# Check nonstationarity condition --> see First Specification

####################################################################################################

#Transform the variable --> First-Differenced Transformation
HDI <- cbind(panel_data$HDI)
dHDI <- diff(HDI, differences=1)
KOF <- cbind(panel_data$KOF)
dKOF <- diff(KOF, differences=1)
KOFE <- cbind(panel_data$KOFE)
dKOFE <- diff(KOFE, differences=1)
KOFS <- cbind(panel_data$KOFS)
dKOFS <- diff(KOFS, differences=1)
KOFP <- cbind(panel_data$KOFP)
dKOFP <- diff(KOFP, differences=1)
FDI <- cbind(panel_data$FDI)
dFDI <- diff(FDI, differences=1)
TradeOpenness <- cbind(panel_data$TradeOpenness)
dTradeOpenness <- diff(TradeOpenness, differences=1)
PopGrowth <- cbind(panel_data$Population.Growth)
dPopGrowth <- diff(PopGrowth, differences=1)
StateFragile <- cbind(panel_data$State.Fragility)
dStateFragile <- diff(StateFragile, differences=1)
Birth <- cbind(panel_data$Birth.Rate)
dBirth <- diff(Birth, differences=1)
Death <- cbind(panel_data$Death.Rate)
dDeath <- diff(Death, differences=1)

#Form the time dummies and transform them --> First-Differenced Time Dummies 
library(fastDummies)
panel_data2 <- dummy_cols(panel_data, select_columns = "Year")
Y1995 <- cbind(panel_data2$Year_1995)
dY1995 <- diff(Y1995, differences=1)
Y1996 <- cbind(panel_data2$Year_1996)
dY1996 <- diff(Y1996, differences=1)
Y1997 <- cbind(panel_data2$Year_1997)
dY1997 <- diff(Y1997, differences=1)
Y1998 <- cbind(panel_data2$Year_1998)
dY1998<- diff(Y1998, differences=1)
Y1999 <- cbind(panel_data2$Year_1999)
dY1999 <- diff(Y1999, differences=1)
Y2000 <- cbind(panel_data2$Year_2000)
dY2000 <- diff(Y2000, differences=1)
Y2001 <- cbind(panel_data2$Year_2001)
dY2001 <- diff(Y2001, differences=1)
Y2002 <- cbind(panel_data2$Year_2002)
dY2002 <- diff(Y2002, differences=1)
Y2003 <- cbind(panel_data2$Year_2003)
dY2003 <- diff(Y2003, differences=1)
Y2004 <- cbind(panel_data2$Year_2004)
dY2004 <- diff(Y2004, differences=1)
Y2005 <- cbind(panel_data2$Year_2005)
dY2005 <- diff(Y2005, differences=1)
Y2006 <- cbind(panel_data2$Year_2006)
dY2006 <- diff(Y2006, differences=1)
Y2007 <- cbind(panel_data2$Year_2007)
dY2007 <- diff(Y2007, differences=1)
Y2008 <- cbind(panel_data2$Year_2008)
dY2008 <- diff(Y2008, differences=1)
Y2009 <- cbind(panel_data2$Year_2009)
dY2009 <- diff(Y2009, differences=1)
Y2010 <- cbind(panel_data2$Year_2010)
dY2010 <- diff(Y2010, differences=1)
Y2011 <- cbind(panel_data2$Year_2011)
dY2011 <- diff(Y2011, differences=1)
Y2012 <- cbind(panel_data2$Year_2012)
dY2012 <- diff(Y2012, differences=1)
Y2013 <- cbind(panel_data2$Year_2013)
dY2013 <- diff(Y2013, differences=1)
Y2014 <- cbind(panel_data2$Year_2014)
dY2014 <- diff(Y2014, differences=1)
Y2015 <- cbind(panel_data2$Year_2015)
dY2015 <- diff(Y2015, differences=1)

###################################################################################################
# FIRST SPECIFICATION
# Run robust OLS regression including the transformed variables and time dummies
model1dummies <- lm(dHDI ~ 0+dKOF+dStateFragile+dPopGrowth+dBirth+dDeath+dY1995+dY1996+dY1997+
                        dY1998+dY1999+dY2000+dY2001+dY2002+dY2003+dY2004+dY2005+dY2006+dY2007+
                        dY2008+dY2009+dY2010+dY2011+dY2012+dY2013+dY2014, data=panel_data2)
cov_model1dummies <- vcovHAC(model1dummies)
robust_se1 <- sqrt(diag(cov_model1dummies))

# Run robust OLS regression including the transformed variables and excluding time dummies
model1without <- lm(dHDI ~ 0+dKOF+dStateFragile+dPopGrowth+dBirth+dDeath, data=panel_data2)
cov_model1without <- vcovHAC(model1without)
robust_se2 <- sqrt(diag(cov_model1without))

stargazer(model1dummies, model1without, type = 'text', se=list(robust_se1, robust_se2), 
          out="model1.txt")


###################################################################################################
# SECOND SPECIFICATION
# Run robust OLS regression including the transformed variables and time dummies
model2dummies <- lm(dHDI ~ 0+dKOFE+dKOFS+dKOFP+dStateFragile+dPopGrowth+dBirth+dDeath+dY1995+dY1996+
                      dY1997+dY1998+dY1999+dY2000+dY2001+dY2002+dY2003+dY2004+dY2005+dY2006+dY2007+
                      dY2008+dY2009+dY2010+dY2011+dY2012+dY2013+dY2014, data=panel_data2)
cov_model2dummies <- vcovHAC(model2dummies)
robust_se3 <- sqrt(diag(cov_model2dummies))

# Run robust OLS regression including the transformed variables and excluding time dummies
model2without <- lm(dHDI ~ 0+dKOFE+dKOFS+dKOFP+dStateFragile+dPopGrowth+dBirth+dDeath, 
                    data=panel_data2)
cov_model2without <- vcovHAC(model2without)
robust_se4 <- sqrt(diag(cov_model2without))

stargazer(model2dummies, model2without, type = 'text', se=list(robust_se3, robust_se4), 
          out="model2.txt")

###################################################################################################
# SECOND SPECIFICATION
# Run robust OLS regression including the transformed variables and time dummies
model3dummies <- lm(dHDI ~ 0+dFDI+dTradeOpenness+dStateFragile+dPopGrowth+dBirth+dDeath+dY1995+
                      dY1996+dY1997+dY1998+dY1999+dY2000+dY2001+dY2002+dY2003+dY2004+dY2005+dY2006+
                      dY2007+dY2008+dY2009+dY2010+dY2011+dY2012+dY2013+dY2014, data=panel_data2)
cov_model3dummies <- vcovHAC(model3dummies)
robust_se5 <- sqrt(diag(cov_model3dummies))

# Run robust OLS regression including the transformed variables and excluding time dummies
model3without <- lm(dHDI ~ 0+dFDI+dTradeOpenness+dStateFragile+dPopGrowth+dBirth+dDeath, 
                    data=panel_data2)
cov_model3without <- vcovHAC(model3without)
robust_se6 <- sqrt(diag(cov_model3without))

stargazer(model3dummies, model3without, type = 'text', se=list(robust_se5, robust_se6), 
          out="model3.txt")


stargazer(model1dummies, model2dummies, model3dummies, type = 'latex', se=list(robust_se1, 
                                                                              robust_se3, 
                                                                              robust_se5), 
          out="modeldummies.tex", align = TRUE, 
          title = "Robust OLS regression with first-differenced variables, Year Dummies included")
stargazer(model1dummies, model2dummies, model3dummies, type = 'text', se=list(robust_se1, 
                                                                               robust_se3, 
                                                                               robust_se5), 
          out="modeldummies.txt", align = TRUE, 
          title = "Robust OLS regression with first-differenced variables, Year Dummies included")


stargazer(model1without, model2without, model3without, type = 'latex', se=list(robust_se2, 
                                                                              robust_se4, 
                                                                              robust_se6), 
          out="modelwithout.tex", align = TRUE, 
          title = "Robust OLS regression with first-differenced variables, Year Dummies excluded")



##################################################################################################
# APPENDIX
library(tidyverse)
library(ggpubr)
attach(mtcars)
ggqqplot(panel_data$HDI, main="QQplot for Human Development Index", xlab = "HDI")
ggqqplot(panel_data$KOF, main="QQplot for KOF Globalization Index", xlab = "KOF")
ggqqplot(panel_data$KOFE, main="QQplot for Economic KOF Globalization Index", xlab = "KOFE")
ggqqplot(panel_data$KOFS, main="QQplot for Social KOF Globalization Index", xlab = "KOFS")
ggqqplot(panel_data$KOFP, main="QQplot for Political KOF GLobalization Index", xlab = "KOFP")
ggqqplot(panel_data$TradeOpenness, main="QQplot for Trade Openness", xlab = "Trade Openness")
ggqqplot(panel_data$FDI, main="QQplot for Net Inflows FDI", xlab = "FDI")
ggqqplot(panel_data$Population.Growth, main="QQplot for Population Growth Rate", xlab = "Population Growth Rate")
ggqqplot(panel_data$State.Fragility, main="QQplot for State Fragility Index", xlab = "State Fragility Index")
ggqqplot(panel_data$GDP.Growth.Rate, main="QQplot for GDP Growth Rate", xlab = "GDP Growth Rate")
ggqqplot(panel_data$Birth.Rate, main="QQplot for Birth Rate", xlab = "Birth Rate")
ggqqplot(panel_data$Death.Rate, main="QQplot for Death Rate", xlab = "Death Rate")

attach(mtcars)
par(mfrow=c(2,3))
plot(KOF, HDI, main="Scatterplot HDI - Overall KOF",
     xlab="KOF Globalization Index ", ylab="HDI ", pch=19)
plot(KOFE, HDI, main="Scatterplot HDI - Economic KOF",
     xlab="Economic KOF Globalization Index ", ylab="HDI ", pch=19)
plot(KOFS, HDI, main="Scatterplot HDI - Social KOF",
     xlab="Social KOF Globalization Index ", ylab="HDI ", pch=19)
plot(KOFP, HDI, main="Scatterplot HDI - Political KOF",
     xlab="Political KOF Globalization Index ", ylab="HDI ", pch=19)
plot(FDI, HDI, main="Scatterplot HDI -  Net Inflows FDI (%GDP)",
     xlab="Net Inflows FDI ", ylab="HDI ", pch=19)
plot(TradeOpenness, HDI, main="Scatterplot HDI - Trade Openness (%GDP)",
     xlab="Trade Openness ", ylab="HDI ", pch=19)



