#Placebo2008

setwd("/Users/lisafadelli/Desktop/LisaFadelli_RScript_Thesis/Placebo/2008/")
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

###PLACEBO2008#######################################################################
y <- c(122:319)
for (placebo in y) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2007,
    special.predictors = list(
      list("lnGDPpc_change", 1998, "mean"),
      list("lnGDPpc_change", 2003, "mean"),
      list("lnGDPpc_change", 2006, "mean")),
    dependent = "lnGDPpc_change",
    unit.variable = "region_no",
    unit.names.variable = "region_name",
    time.variable = "year",
    treatment.identifier = placebo,
    controls.identifier = y[!y %in% placebo],
    time.optimize.ssr = 1997:2007,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0(placebo,"placebo", "gaps"), gaps)
  write.table((assign(paste0(placebo,"placebo", "gaps"), gaps)), paste0(placebo,"placebo", "gaps",".txt"), sep = " ", 
              quote = FALSE, row.names = T, dec = ",", eol="\r")
  #Visualize and export Synth tables
  synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
  names(synth.tables)
  print(synth.tables)
  name <- paste0(placebo, "placebo")
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
            Ylab = "Gap in GDP growth rate per capita",
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

y <- c(122:319)
for (placebo in y) {
  placebogaps <- read.table(paste0(placebo,"placebogaps.txt"), sep="", dec = ",")
  assign(paste0(placebo,"placebo", "gaps"), placebogaps)}

save.image("~/Desktop/LisaFadelli_RScript_Thesis/Placebo/2008/2008.RData")
do.placebo2008 <- do.call(cbind,lapply(paste0(y,"placebo","gaps"), get))
write.table(do.placebo2008, file="gapsplacebo2008.txt", sep=",", quote=FALSE, row.names=T)

do.placebo2008 <- as.data.frame(do.placebo2008)


gapsCyprus <- read.csv("~/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/gapsCyprus.txt")
png("Placebo2008_CY.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2008), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2008 with Cyprus",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(gapsCyprus, lwd = 2)
abline(v=12, lty=2)
abline (h = 0, lty = 5)
dev.off()


gapsMT <- read.csv("~/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/gapsMT.txt", row.names="V1")
png("Placebo2008_MT.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2008), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2008 with Malta",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(gapsMT, lwd = 2)
abline(v=12, lty=2)
abline (h = 0, lty = 5)
dev.off()


z <- c(100:101)
for(i in z) {  
  gapsMTregions <- read.csv(paste0("/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/",
                                   i,"gaps.txt"))
  assign(paste0(i,"gaps"), gapsMTregions)}  

#Region_Plots
png("Placebo2008_100.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2008), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2008 with 100",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`100gaps`, lwd = 2)
abline(v=12, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2008_101.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2008), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2008 with 101",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`101gaps`, lwd = 2)
abline(v=12, lty=2)
abline (h = 0, lty = 5)
dev.off()


