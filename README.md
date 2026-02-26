# Economics-related projects
*A collection of projects delivered during my Master of Science in Economics at the Universität Hamburg (2020-2022)*

This repository contains various economic analysis projects, econometric models and empirical studies developed as part of my MSc in Economics.  
The projects cover diverse topics, ranging from macroeconomic analysis to applied econometrics, using statistical software like R and STATA. 
Each project is categorized by its level of complexity and provides insights into different areas of economic research.

## Table of Contents:
- [Master Thesis](Master_Thesis)
- [Working Paper: Globalization and Human Development Index](Globalization_Impact)
- [Replication and Working Paper: Uber and Public Transit](Uber_Transit)
- [Replication Paper: Double Taxation and Foreign Direct Investment](Replication_Paper)
- [Working Paper: COVID-19 and Mask-Wearing](COVID_Working_Paper)

## Projects

### 1) "Assessing the effect of common currency on economic growth in Eastern European transition countries: A Synthetic Control Approach"

**Level**: Advanced  
**Tools Used**: R  
**Assignment**: Master Thesis  
**Summary**:   
This thesis assesses the impact of the common currency (Euro) on the economic growth of Eastern European transition countries using a Synthetic Control Method. The study compares the economic performance of countries that adopted the Euro to a synthetic control group constructed using data from countries that did not.

### 2) "The impact of globalization on the Human Development Index in South and Southeast Asian countries"

**Level**: Beginner  
**Tools Used**: R  
**Assignment**: Working Paper  
**Summary**:   
This study aims to investigate the effect of globalization on human development 
with a panel of data from 1995 to 2015 for some South and South-East Asian 
countries. To correct the unobserved heterogeneity that characterizes the panel 
dataset, a Two-Ways Fixed Effects model was executed. However, after 
detecting the non-stationarity of the variables, a robust OLS regression with first
differences variables seems to correct the issue, providing results generally in 
line with the expectations. I ran three different regressions. One uses the first
differenced overall KOF Globalization Index as the main independent variable of 
interest; the second aims to analyze the impact of each of the three aspects of 
globalization:  Economic, Social and Political globalization. The third specification 
includes two proxies for the economic side of globalization: the sum of imports 
and exports as per cent GDP, and the net inflows of Foreign Direct Investments 
as per cent GDP.  Results reveal that the KOF Globalization Index had a 
significant effect on the HDI. More specifically, social globalization had a higher 
impact with respect to the other two sides. The openness to trade generated 
growth in the HDI; on the contrary, a negative effect has been encountered in the 
relationship between the FDIs and human development. 

### 3) "Is Uber a substitute or complement for public transit?"

**Level**: Advanced  
**Tools Used**: STATA  
**Assignment**: Replication Paper + Working Paper  
**Summary**:   
The study conducted by Hall and et. has shown that Uber is a complement for the average transit agency, increasing ridership after two years from the entry date into the Metropolitan Statistical Area in the United States, and the effect grew over time.  
With the outbreak of the Covid-19 pandemic, a reduction in traffic was observed worldwide (Statista, 2021), and the extension part of this paper tries to investigate the effect of new weekly Covid-19 cases on Uber usage in several MSAs across the U.S.., using the Google Trend search intensity as a proxy. The concluding results show a tiny decrease in the Google Trend index as the cases increased.

### 4) "Impact of double taxation treaties on foreign direct investment: evidence form large dyadic panel data"

**Level**: Intermediate  
**Tools Used**: STATA  
**Assignment**: Replication Paper  
**Summary**:   
In the paper, the authors, F. Barthel, M. Busse and E. Neumayer, have examined one important policy instrument, namely, the impact of DTTs on FDI stocks in host economies. The main advantage of this empirical analysis is that they used an impressive number of host and source countries in order to avoid sample selection bias. 
The static model is not taken into consideration because it is very likely that the Foreign Direct Investment stocks are highly correlated with the events in the past, and this is also showed in the GMM Arellano Bond estimation where the variable 𝑙𝑛𝑓𝑑𝑖𝑖𝑛𝑠𝑡𝑜𝑐𝑘𝑖,𝑡−1 is statistically significant. Additionally, when using the GMM Arellano Bond estimator we have to rely on a large dataset, because it is consistent and asymptotically efficient when the sample size tends to infinity. Furthermore, this estimation is valid only if there is no autocorrelation in the idiosyncratic error. 
The explanatory variable of interest, dtt_age is highly significant in the regression, exhibiting the positive impact of the DTTs on the FDI.  
According to the analysis conducted in this replication paper, all three methods implemented by the authors present some issues. As a result, the most suitable one is the GMM Arellano Bond estimator assuming the appropriate modifications have been added in the regression model.  
We attempt to address each of the potential issues. First, there is a possibility we are dealing with invalid instruments. We attempt to run the regression with maximum 2 lags of variables instead of maximum 6, in order to correctly specify the model, and we also try to treat the variable ℎ𝑜𝑠𝑡𝑔𝑑𝑝𝑡𝑜𝑡𝑙𝑛𝑖,𝑡 as explicitly endogenous. However, the outcome is still problematic since the null hypothesis of the Sargan Test is rejected.  
This indicates that instruments are not exogenous or that the model is not well specified.

### 5) "The effect of wearing masks to protect against COVID-19 infection on the 7-day incident rate: evidence from Arkansas state"

**Level**: Beginner  
**Tools Used**: STATA  
**Assignment**: Working Paper  
**Summary**:  
We have focused on the Executive Order 20-43 signed by the Governor of Arkansas, requiring a state-wide face mask requirement from the 20th of July 2020 and we have developed our analysis on how mask wearing has affected number of new daily infections from Covid-19. 
We used two different methods: the Difference-in-Differences design and the Synthetic Control Group method. 
In the Difference-in-Differences approach, we have run three different specifications using three different control states, Missouri, Tennessee and Oklahoma. We selected those three states since none of them has issued a similar treatment during that period; moreover, according to a recent study, those three states are the most similar to Arkansas in all United States. 
The DiD results using Tennessee and then Oklahoma as control group were not significant, while using Missouri as control, the DiD design shows a significant variation in the 7 days incidence rate, with a decrease of almost 30 new cases in the 7 days incidence rate every 100,000 inhabitants.  
Then, we have developed the Synthetic Control Group method. The first specification included also some states which have issued during that period of time the same treatment: since this represents a violation of the common trend assumption, we have kept only the states that could have been a good control. The second specification showed an increase in the 7-day incidence rate and a later decrease after twenty days from the intervention day. 
In order to providing support for the identification assumption in the Synthetic Control Group method, we have conducted two placebo regressions: in-time placebo test, where the intervention artificially takes place one month earlier, and the in-space placebo test, where the intervention artificially takes place in a control group from the donor pool. In both cases, the confidence that the face covering intervention has an effect on the outcome is rejected since both graphs the curves deviates, so we cannot state that the change is due to the treatment itself. 

---

## Licence
This repository is licensed under the MIT License.

---

## Contact
Feel free to reach out for any questions or feedback regarding these projects!  
**Email**: lisafadelli1998@gmail.com
**LinkedIn**: www.linkedin.com/in/lisa-fadelli
