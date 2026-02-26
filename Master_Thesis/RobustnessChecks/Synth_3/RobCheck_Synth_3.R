# Second Robustness Check

setwd("/Users/lisafadelli/Desktop/LisaFadelli_RScript_Thesis/RobustnessChecks/Synth_3")
library(readxl)
library (dplyr)
library(tidyr)
library(Synth)
library(tidysynth)
library(writexl)

###DATASET_PREPARATION##############################################################################
ost <- read_excel("ost.xlsx")
ost <- as.data.frame(ost)
Year <- matrix (data = 1997:2018, nrow = 22, ncol=1)

###CYPRUS########################################################################################
dataprep.out <- dataprep(
  foo = ost,
  predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                 "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
  predictors.op = "mean",
  time.predictors.prior = 1997:2007,
  dependent = "lnGDPpc_change",
  unit.variable = "region_no",
  unit.names.variable = "region_name",
  time.variable = "year",
  treatment.identifier = 1,
  controls.identifier = c(122:319),
  time.optimize.ssr = 1997:2007,
  time.plot = 1997:2018)
#synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                   quadopt = "LowRankQP", verbose=FALSE)
synth.out[["loss.w"]]
synth.out[["loss.v"]]
#Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
#be calculated in this way
gapsCyprus <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
gapsCyprus
write.table(gapsCyprus, file="gapsCyprus.txt", sep = ",", quote = FALSE, row.names = T)
#Visualize and export Synth tables
synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
names(synth.tables)
print(synth.tables)
write.table(synth.tables[["tab.w"]], file="weightsCyprus.txt", sep = ",", quote = FALSE, 
            row.names = T)
write.table(synth.tables[["tab.pred"]], file="predCyprus.txt", sep = ",", quote = FALSE, 
            row.names = T)
write.table(synth.tables[["tab.loss"]], file="lossCyprus.txt", sep = ",", quote = FALSE, 
            row.names = T)
write.table(synth.tables[["tab.v"]], file="vCyprus.txt", sep = ",", quote = FALSE, 
            row.names = T)


#Plot
png("Cyprus.png", width=630, height = 350)
path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
          Ylab = "lnGDP per capita change", 
          Xlab = "Year",
          Ylim = c(-0.3,0.3),
          Main = "Cyprus",
          Legend.position = "bottomright" )
abline(v=2008, lty=2)
dev.off()
png("CyprusGaps.png", width=630, height = 350)
gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
          Ylab = "Gap in lnGDP per capita change",
          Xlab = "Year",
          Ylim = c(-0.2, 0.2),
          Main = "Gaps Cyprus")
abline(v=2008, lty = 2)
dev.off()

#AverageTreatmentEffect
Cyprus_ATT<-gapsCyprus[12:22, ]
Cyprus_ATT <- sum(Cyprus_ATT, na.rm=FALSE)
Cyprus_ATT <- Cyprus_ATT / 11
Cyprus_ATT
write.table(Cyprus_ATT, file="ATTCyprus.txt", sep = ",", quote = FALSE, row.names = T)



###ESTONIA#######################################################################
x <- c(78:82)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2010,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2010,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2011, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2011, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixEE <- do.call(cbind, lapply(paste0("gaps", 78:82), get))
write.table(do.matrixEE, file="gapsregionsEE.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixEE2 <- apply (do.matrixEE, 1, sum)
do.matrixEE2 <- as.matrix(do.matrixEE2)
gapsEE <- do.matrixEE2 / 5
gapsEE <- cbind(Year, gapsEE)
write.table(gapsEE, file="gapsEE.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("EstoniaGaps.png", width=630, height = 350)
plot(gapsEE, type="l", lwd=2,  
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Estonia Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2011, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixEE<-as.data.frame(do.matrixEE)
EE <- colSums(do.matrixEE[c("2011","2012","2013","2014","2015","2016","2017","2018"), ])
EE<-as.matrix(EE)
EE_regions_ATT <- EE/8
write.table(EE_regions_ATT, file="EE_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Estonia_ATT<-gapsEE[15:22,2 ]
Estonia_ATT <- sum(Estonia_ATT, na.rm=FALSE)
Estonia_ATT <- Estonia_ATT / 8
Estonia_ATT
write.table(Estonia_ATT, file="EstoniaATT.txt", sep = ",", quote = FALSE, row.names = T)



###LITHUANIA########################################################################################
x <- c(83:92)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2014,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2014,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2015, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2015, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixLT <- do.call(cbind, lapply(paste0("gaps", 83:92), get))
write.table(do.matrixLT, file="gapsregionsLT.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixLT2 <- apply (do.matrixLT, 1, sum)
do.matrixLT2 <- as.matrix(do.matrixLT2)
gapsLT <- do.matrixLT2 / 10
gapsLT <- cbind(Year, gapsLT)
write.table(gapsLT, file="gapsLT.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("LithuaniaGaps.png", width=630, height = 350)
plot(gapsLT, type="l",lwd=2,
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Lithuania Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2015, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixLT<-as.data.frame(do.matrixLT)
LT <- colSums(do.matrixLT[c("2015","2016","2017","2018"), ])
LT<-as.matrix(LT)
LT_regions_ATT <- LT/4
write.table(LT_regions_ATT, file="LT_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Lithuania_ATT<-gapsLT[19:22,2 ]
Lithuania_ATE <- sum(Lithuania_ATE, na.rm=FALSE)
Lithuania_ATE <- Lithuania_ATE / 4
Lithuania_ATE
write.table(Lithuania_ATT, file="Lithuania_ATT.txt", sep = ",", quote = FALSE, row.names = T)

###LATVIA########################################################################################
x <- c(94:99)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2013,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2013,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2014, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2014, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixLV <- do.call(cbind, lapply(paste0("gaps", 94:99), get))
write.table(do.matrixLV, file="gapsregionsLV.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixLV2 <- apply (do.matrixLV, 1, sum)
do.matrixLV2 <- as.matrix(do.matrixLV2)
gapsLV <- do.matrixLV2 / 6
gapsLV <- cbind(Year, gapsLV)
write.table(gapsLV, file="gapsLV.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("LatviaGaps.png", width=630, height = 350)
plot(gapsLV, type="l",lwd=2,     
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Latvia Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2014, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixLV<-as.data.frame(do.matrixLV)
LV <- colSums(do.matrixLV[c("2014","2015","2016","2017","2018"), ])
LV<-as.matrix(LV)
LV_regions_ATT <- LV/5
write.table(LV_regions_ATT, file="LV_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Latvia_ATT<-gapsLV[18:22,2 ]
Latvia_ATT <- sum(Latvia_ATT, na.rm=FALSE)
Latvia_ATT <- Latvia_ATT / 5
Latvia_ATT
write.table(Latvia_ATT, file="Latvia_ATT.txt", sep = ",", quote = FALSE, row.names = T)

###MALTA########################################################################################
x <- c(100:101)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2007,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2007,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2008, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2008, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixMT <- do.call(cbind, lapply(paste0("gaps", 100:101), get))
write.table(do.matrixMT, file="gapsregionsMT.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixMT2 <- apply (do.matrixMT, 1, sum)
do.matrixMT2 <- as.matrix(do.matrixMT2)
gapsMT <- do.matrixMT2 / 2
gapsMT <- cbind(Year, gapsMT)
write.table(gapsMT, file="gapsMT.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("MaltaGaps.png", width=630, height = 350)
plot(gapsMT, type="l",lwd=2,
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Malta Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2008, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixMT<-as.data.frame(do.matrixMT)
MT <- colSums(do.matrixMT[c("2008","2009","2010","2011","2012","2013","2014","2015","2016",
                            "2017","2018"), ])
MT<-as.matrix(MT)
MT_regions_ATT <- MT/11
write.table(MT_regions_ATT, file="MT_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Malta_ATT<-gapsMT[12:22,2 ]
Malta_ATT <- sum(Malta_ATT, na.rm=FALSE)
Malta_ATT <- Malta_ATT / 11
Malta_ATT
write.table(Malta_ATT, file="Malta_ATT.txt", sep = ",", quote = FALSE, row.names = T)


###SLOVENIA########################################################################################
x <- c(102:113)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS","h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2006,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2006,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2007, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2007, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixSI <- do.call(cbind, lapply(paste0("gaps", 102:113), get))
write.table(do.matrixSI, file="gapsregionsSI.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixSI2 <- apply (do.matrixSI, 1, sum)
do.matrixSI2 <- as.matrix(do.matrixSI2)
gapsSI <- do.matrixSI2 / 12
gapsSI <- cbind(Year, gapsSI)
write.table(gapsSI, file="gapsSI.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("SloveniaGaps.png", width=630, height = 350)
plot(gapsSI, type="l",lwd=2,
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Slovenia Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2007, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixSI<-as.data.frame(do.matrixSI)
SI <- colSums(do.matrixSI[c("2007","2008","2009","2010","2011","2012","2013","2014","2015","2016",
                            "2017","2018"), ])
SI<-as.matrix(SI)
SI_regions_ATT <- SI/12
write.table(SI_regions_ATT, file="SI_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Slovenia_ATT<-gapsSI[11:22,2 ]
Slovenia_ATT <- sum(Slovenia_ATT, na.rm=FALSE)
Slovenia_ATT <- Slovenia_ATT / 12
Slovenia_ATT
write.table(Slovenia_ATT, file="Slovenia_ATT.txt", sep = ",", quote = FALSE, row.names = T)

###SLOVAKIA########################################################################################
x <- c(114:121)
for (region in x) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2008,
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = region,
    controls.identifier = c(122:319),
    time.optimize.ssr = 1997:2008,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps",region), gaps)
  write.table((assign(paste0("gaps",region), gaps)), paste0(region, "gaps",".txt"), sep = ",", 
              quote = FALSE, row.names = T)
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(region)
  write.table(synth.tables[["tab.pred"]], paste0((name), "pred",".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.w"]], paste0((name), "weights", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.loss"]], paste0((name), "loss", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  write.table(synth.tables[["tab.v"]], paste0((name), "v", ".txt"), sep = ",", quote = FALSE, 
              row.names = T)
  #Region_Plots
  png(paste0(name, "gaps",".png"), width=630, height = 350)
  gaps.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "Gap in lnGDP per capita change",
            Xlab = "Year",
            Ylim = c(-0.2, 0.2))
  abline(v=2009, lty = 2)
  dev.off()
  png(paste0(name,".png"), width=630, height = 350)  
  path.plot(synth.res=synth.out, dataprep.res = dataprep.out,
            Ylab = "lnGDP per capita change", 
            Xlab = "Year",
            Ylim = c(-0.3,0.3))
  abline(v=2009, lty=2)
  dev.off()
}
#Aggregate regional results together
do.matrixSK <- do.call(cbind, lapply(paste0("gaps", 114:121), get))
write.table(do.matrixSK, file="gapsregionsSK.txt", sep = ",", quote = FALSE, row.names = T)
do.matrixSK2 <- apply (do.matrixSK, 1, sum)
do.matrixSK2 <- as.matrix(do.matrixSK2)
gapsSK <- do.matrixSK2 / 8
gapsSK <- cbind(Year, gapsSK)
write.table(gapsSK, file="gapsSK.txt", sep = ",", quote = FALSE, row.names = T)
#Plot
png("SlovakiaGaps.png", width=630, height = 350)
plot(gapsSK, type="l",lwd=2,
     ylab = "Gap in lnGDP per capita change",
     xlab = "Year",
     main = "Slovakia Gaps",
     ylim = c(-0.2, 0.2))
abline(v=2009, lty = 2)
abline (h = 0, lty = 5)
dev.off()
#AverageTreatmentEffect
do.matrixSK<-as.data.frame(do.matrixSK)
SK <- colSums(do.matrixSK[c("2009","2010","2011","2012","2013","2014","2015","2016",
                            "2017","2018"), ])
SK<-as.matrix(SK)
SK_regions_ATT <- SK/10
write.table(SK_regions_ATT, file="SK_regions_ATT.txt", sep = ",", quote = FALSE, row.names = T)
Slovakia_ATT<-gapsSK[13:22,2 ]
Slovakia_ATT <- sum(Slovakia_ATT, na.rm=FALSE)
Slovakia_ATT <- Slovakia_ATT / 10
Slovakia_ATT
write.table(Slovakia_ATT, file="Slovakia_ATT.txt", sep = ",", quote = FALSE, row.names = T)





save.image("~/Desktop/LisaFadelli_RScript_Thesis/RobustnessChecks/Synth_3/Synth_3.RData")

