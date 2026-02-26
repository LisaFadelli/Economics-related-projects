# The impact of globalization on the Human Development Index in South and Southeast Asian countries 
 
##### SUBMISSION DATE:
18.02.2022

---

This repository contains the analysis and code for the project performed as part of my Master's seminar in Economics. 
The project uses econometric techniques in R to analyze the effects of globalization on human development across selected countries in South and Southeast Asia.

## METHODOLOGY
This study aims to investigate the effect of globalization on human development using panel data from 1995 to 2015 for selected South and Southeast Asian countries. The study employs a *Two-Ways Fixed Effects* model to correct for unobserved heterogeneity in the panel data. After detecting the non-stationarity of the variables, a robust OLS regression with first-differenced variables was used. The analysis includes three different regressions:  
1. The overall KOF Globalization Index.  
2. The three aspects of globalization: Economic, Social, and Political globalization.  
3. Economic globalization proxies, including trade openness and foreign direct investment (FDI) as a percentage of GDP.  

Results indicate that the KOF Globalization Index has a significant positive effect on HDI, with social globalization showing a higher impact than economic and political globalization.


## DATASET 
The dataset used for this analysis consists of data from 1995 to 2015 for countries in South and Southeast Asia. Key variables include:
- **Human Development Index (HDI)**
- **KOF Globalization Index** (Overall, Economic, Social, and Political components)
- **Trade Openness** (Imports + Exports as % of GDP)
- **Foreign Direct Investment (FDI)** as % of GDP


## SOFTWARE REQUIREMENT: 
This project is implemented in **R**. To run the analysis, the following R packages are required:
- `dplyr`
- `ggplot2`
- `lmtest`
- `sandwich`


## ANALYSIS OVERVIEW:  
The R script **RScript - Paper - Lisa Fadelli.R** contains the following sections:
1) *Data Import and Preprocessing*: Loading and cleaning the dataset
2) *Econometric Modeling*: Running the regression models, including the Two-Ways Fixed Effects and robust OLS regression
3) *Results and Visualizations*: Generating plots and tables to present the findings
4) *Conclusion*: Summarizing the results and implications for policy

---

## KEY INSIGHTS:
This project was my introduction to R programming for statistical analysis, and I faced challenges particularly around handling non-stationary variables and model selection.   
I initially used the Two-Way Fixed Effects model but later switched to robust OLS regression with first-differenced variables due to issues with stationarity.  
One of the key takeaways from this project was understanding the importance of properly addressing unobserved heterogeneity and applying fixed-effects models to panel data.  
I also gained hands-on experience with data wrangling, statistical testing (e.g., unit root tests, F-tests, Hausman tests), and interpreting results from complex econometric models.  
Although I used common proxies like trade openness and FDI for economic globalization, I realized these only partially capture the full complexity of globalization’s effects.