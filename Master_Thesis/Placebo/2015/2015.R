#Placebo2015

setwd("/Users/lisafadelli/Desktop/LisaFadelli_RScript_Thesis/Placebo/2015")
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

###PLACEBO2015#######################################################################
y <- c(122:319)
for (placebo in y) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2014,
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
    time.optimize.ssr = 1997:2014,
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

save.image("~/Desktop/LisaFadelli_RScript_Thesis/Placebo/2015/2015.RData")

do.placebo2015 <- do.call(cbind,lapply(paste0("gaps","placebo",y), get))
write.table(do.placebo2015, file="gapsplacebo2015.txt", sep=",", quote=FALSE, row.names=T)

do.placebo2015 <- as.data.frame(do.placebo2015)

gapsLT <- read.csv("~/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/gapsLT.txt", row.names = "V1")
png("Placebo2015_LT.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with Lithuania",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(gapsLT, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

z <- c(83:92)
for(i in z) {  
  gapsLTregions <- read.csv(paste0("/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/",
                                   i,"gaps.txt"))
  assign(paste0(i,"gaps"), gapsLTregions)}  

png("Placebo2015_83.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 83",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`83gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_84.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 84",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`84gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_85.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 85",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`85gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_86.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 86",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`86gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_87.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 87",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`87gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_88.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 88",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`88gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_89.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 89",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`89gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_90.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 90",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`90gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_91.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 91",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`91gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2015_92.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2015), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2015 with 92",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`92gaps`, lwd = 2)
abline(v=19, lty=2)
abline (h = 0, lty = 5)
dev.off()






