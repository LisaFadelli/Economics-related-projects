#Placebo2011

setwd("/Users/lisafadelli/Desktop/LisaFadelli_RScript_Thesis/Placebo/2011")
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

###PLACEBO2011#######################################################################
y <- c(122:319)
for (placebo in y) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2010,
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
    time.optimize.ssr = 1997:2010,
    time.plot = 1997:2018)
  #synth() solves for the diagonal matrix V* that minimizes the MSPE for the pre-intervention period
  synth.out <- synth(data.prep.obj = dataprep.out, optimxmethod = "BFGS", genoud=FALSE, 
                     quadopt = "LowRankQP", verbose=FALSE)
  #Annual discrepancies in the GDP trend between the treated region and its synthetic counterpart may 
  #be calculated in this way
  gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
  gaps
  assign(paste0("gaps","placebo",placebo), gaps)
  write.table((assign(paste0("gaps","placebo",placebo), gaps)), paste0(placebo,"placebo", "gaps",".txt"), sep = " ", 
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

save.image("~/Desktop/LisaFadelli_RScript_Thesis/Placebo/2011/2011.RData")

do.placebo2011 <- do.call(cbind,lapply(paste0("gaps","placebo",y), get))
write.table(do.placebo2011, file="gapsplacebo2011.txt", sep=",", quote=FALSE, row.names=T)

do.placebo2011 <- as.data.frame(do.placebo2011)

gapsEE <- read.csv("~/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/gapsEE.txt", row.names = "V1")
png("Placebo2011_EE.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with Estonia",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(gapsEE, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()

# Placebo effect for each treated region
z <- c(78:82)
for(i in z) {  
  gapsEEregions <- read.csv(paste0("/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/",
                                   i,"gaps.txt"))
  assign(paste0(i,"gaps"), gapsEEregions)}  

#Region_Plots
png("Placebo2011_78.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with 78",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`78gaps`, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2011_79.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with 79",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`79gaps`, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2011_80.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with 80",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`80gaps`, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2011_81.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with 81",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`81gaps`, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2011_82.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2011), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2011 with 82",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`82gaps`, lwd = 2)
abline(v=15, lty=2)
abline (h = 0, lty = 5)
dev.off()


