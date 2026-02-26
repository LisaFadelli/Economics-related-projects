# MASTER’S THESIS 
## "ASSESSING THE EFFECT OF THE COMMON CURRENCY ON ECONOMIC GROWTH IN EASTERN EUROPEAN TRANSITION COUNTRIES: A SYNTHETIC CONTROL APPROACH" 
 
##### SUBMISSION DATE:
27.10.2022 

The folder contains: 
- BaselineModel (it includes script and dataset to run the first model specification, the baseline model)
- RobustnessChecks (it includes script and dataset to run the robustness checks)
- Placebo (it includes script and dataset to run the placebo tests)
- Tables.xlsx (excel file with the tables added to the thesis)

## DATASET 
The Dataset used can be found as an excel file as “Dataset.xlsl” 

## SOFTWARE REQUIREMENT: 
RStudio 
*Packages to be installed*:  
- library(readxl)
- library (dplyr)
- library(tidyr)
- library(Synth)
- library(tidysynth)
- library(writexl) 

## INSTRUCTION:  
Download the folder and move it to the Desktop.  
Change the beginning of the working directory in the first lines setwd *"/Users/lisafadelli"* with the beginning of the real path name where the folder has been saved 
**For the R Scripts**:   
- BaselineModel -> Open Synth_1.R 
- RobustnessChecks -> Open RobCheck_Synth_2.R -> Open RobCheck_Synth_3.R 
- Placebo -> For each year, open “year”.R
