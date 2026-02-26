#Placebo2007

setwd("/Users/lisafadelli/Desktop/LisaFadelli_RScript_Thesis/Placebo/2007")
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

###PLACEBO2007#######################################################################
y <- c(122:319)
for (placebo in y) {
  dataprep.out <- dataprep(
    foo = ost,
    predictors = c("k98","k_p98","GVA_Agr","GVA_Ind", "GVA_Trade","GVA_Constr", 
                   "GVA_FBS", "h98_Trade", "dwellings2000", "urban", "modern", "av_age_ln"),
    predictors.op = "mean",
    time.predictors.prior = 1997:2006,
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
    time.optimize.ssr = 1997:2006,
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

save.image("~/Desktop/LisaFadelli_RScript_Thesis/Placebo/2007/2007.RData")
do.placebo2007 <- do.call(cbind,lapply(paste0("gaps","placebo",y), get))
write.table(do.placebo2007, file="gapsplacebo2007.txt", sep=",", quote=FALSE, row.names=T)

do.placebo2007 <- as.data.frame(do.placebo2007)


gapsSI <- read.csv("~/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/gapsSI.txt", row.names="V1")
png("Placebo2007_SI.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with Slovenia",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(gapsSI, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()


# Placebo effect for each treated region
data_files <- list.files("/Desktop/LisaFadelli_RScript_Thesis/BaselineModel") 
data_files

z <- c(102:113)
for(i in z) {  
    gapsSIregions <- read.csv(paste0("/Desktop/LisaFadelli_RScript_Thesis/BaselineModel/",
                                       i,"gaps.txt"))
    assign(paste0(i,"gaps"), gapsSIregions)}  

#Region_Plots
png("Placebo2007_102.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 102",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`102gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_103.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 103",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`103gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_104.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 104",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`104gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_105.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 105",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`105gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_106.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 106",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`106gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_107.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 107",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`107gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_108.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 108",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`108gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_109.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 109",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`109gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_110.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 110",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`110gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_111.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 111",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`111gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_112.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 112",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`112gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

png("Placebo2007_113.png", width=630, height = 350)
matplot(as.data.frame(do.placebo2007), type="l", col="grey", lwd=1, lty=1,
        ylab = "Gap in lnGDP per capita change",
        xlab = "Year",
        main="Placebo 2007 with 113",
        axes = F)
axis(2)
Year <- seq.int(from = 1997 ,to = 2018)
axis(side = 1, at = 1:22, labels = paste(Year))
lines(`113gaps`, lwd = 2)
abline(v=11, lty=2)
abline (h = 0, lty = 5)
dev.off()

