### Loading Packages
##```{r preparation-load-packages, message = FALSE, warning = FALSE}
# load necessary library and packages for the analysis
library(dplyr) 
library(tidyr)
library(readxl)
library(RColorBrewer)

library(ggplot2)
library(table1)
library(arsenal)
library(gtsummary)
library(corrplot)
library(rcompanion)
library(knitr)
library(rpivotTable)
library(flexdashboard)
library(DT)
library(car) 
library(rms)
library(leaps)
library(psych)
library(pca3d)
library(animation)
library(gt)
library(nortest)
library(DT)
library(sandwich)
library(lmtest)
library(wooldridge)
library(table1)
library(arsenal)
library(gtsummary)
library(gt)
library(corrplot)
library(xtable)
library(rcompanion)
library(car)
library(rstatix)

#library(factoexrta)
library(caret) # install 'caret' package with 'dependencies=TRUE' turned on
library(AER)   
library(plm)    
library(stargazer)      
library(lattice)
library(ivreg) # IV-regression

getwd()
# change to desired working directory with all relevant files 
setwd("C:/Users/User/Desktop")
anova_test_sad = read.csv(file = 'ANOVA_test_sad.csv', header = TRUE)
head(anova_test_sad)

class(anova_test_sad)# check if data frame else conver to data.table


library(data.table) # for converting data frame to data.table object

setDT(anova_test_sad) # this is to convert anova_test_sad data frame to a data table

#convert from wide to long
df_long <- melt(data = anova_test_sad, 
                id.vars = c("pMail"),
                variable.name = "Questions",
                value.name = "Sad_Ratings")
 df_long
 
 write.table(df_long, "anova_test_sad_long.csv", row.names=FALSE, sep=",")

#computing some summary statisitcs of sad_ratings by point_in_time(questions)
 
 df_long %>%
   group_by(Questions) %>%
   get_summary_stats(Sad_Ratings, type = "mean_sd") %>%
 write_csv("anova_sad_summary_output.csv")
 #interpretation : mean of 12b and 13b is .16 and 2.6 but 14b and 15b is at 1.6
 
 
 install.packages("ggplot2")
 install.packages("ggpubr")
 library(ggpubr)
 library(tidyverse)
 
 #identify outliers
 df_long %>%
   group_by(Questions) %>%
   identify_outliers(Sad_Ratings)
 #conclusion there are 15 mild outliers, none extreme, represented as the largest
 #value in the dataset.
 #we need to understand why they appeared and whether it is likely they will continue to appear
 #interpretation1 - 1st grp - they were already sad on > 3 and listening to sad songs made them
 #even worse.
 # 2nd interpretation : for the same outlier groups listening to happy and energetic songs did not 
 #improve their sad emotions
 
 
 
# Check for normality thru shapiro test and qq plot. As sample size is > 50,
 #use qqplot, but the points do not exactly fall on reference point for each time point
 df_long %>%
   group_by(Questions) %>%
   shapiro_test(Sad_Ratings)
 
 ggqqplot(df_long, "Sad_Ratings", facet.by = "Questions")
 
 #box plot to show the means for each time point i.e after listening to the audio clip
 
 
 bxp <- ggboxplot(df_long, x = "Questions", y = "Sad_Ratings", add = "jitter", color = "Questions", palette =c("#00AFBB", "#E7B800", "#FC4E07","#FC3E09"))
 bxp
 
 #interpretation, lower quartile is defined as 25th percentile and upper quartile 
 #is defined as 75th percentile, (Q3 - Q1) is the interquartile range
 
 p1 <- ggpar(bxp, 
             title = "Boxplot Comparing Sad Ratings Across All Time Points",
             caption = "Source: ggpubr",
             xlab ="Time Points", 
             ylab = "Sad Ratings",
             legend.title = "Time Points Measured (Pre and Post)")
 p1 
 
 #Computation 1 - anova
 
 res.aov <- anova_test(data = df_long, dv = Sad_Ratings, wid = pMail, within = Questions)
 get_anova_table(res.aov)
 
 #Computation 2 - pair-wise comparison - t-test
 
 # pairwise comparisons
 pwc <- df_long %>%
   pairwise_t_test(
     Sad_Ratings ~ Questions, paired = TRUE,
     p.adjust.method = "bonferroni"
   )%>%
   pwc
 write_csv("pair-wise_sad_summary_output.csv")
 #Interpretation : Pair-wise difference btw time points were statistically significant
 #different as (p<=0.005)
 
 
 #----------------------------------------------------------------------------
 
 anova_test_happy = read.csv(file = 'ANOVA_test_happy.csv', header = TRUE)
 head(anova_test_happy)
 
 class(anova_test_happy)# check if data frame else convert to data.table
 
 setDT(anova_test_happy) # this is to convert anova_test_sad data frame to a data table
 
 df_long_2 <- melt(data = anova_test_happy, 
                 id.vars = c("pMail"),
                 variable.name = "Questions",
                 value.name = "Happy_Ratings")
 df_long_2
 
 write.table(df_long_2, "anova_happy_long.csv", row.names=FALSE, sep=",")
 
 df_long_2 %>%
   group_by(Questions) %>%
   get_summary_stats(Happy_Ratings, type = "mean_sd")%>%
 write_csv("anova_happy_summary_output.csv")
 #interpretation : mean of 12a and 13a is 3.33 and 3.07 but 14a and 15a is at 3.90 and 3.56
 
 #checking for outliers
 df_long_2 %>%
   group_by(Questions) %>%
   identify_outliers(Happy_Ratings)
 #interpretation 1 : 3 mild outliers - they were least happy at a scale of 1 and after 
 #listenig to sad songs, happy and energetic songs they either had no change or became slightly happy
 #interpretation 2: the type of music clusters  did not matter in uplifting their mood when they were 
 #already least happy to start of with
 
 # Check for normality thru shapiro test and qq plot. As sample size is > 50,
 #use qqplot, but the points do not exactly fall on reference point for each time point
 df_long_2 %>%
   group_by(Questions) %>%
   shapiro_test(Happy_Ratings)
 
 ggqqplot(df_long_2, "Happy_Ratings", facet.by = "Questions")
 
 
 
 bxp2 <- ggboxplot(df_long_2, x = "Questions", y = "Happy_Ratings", add = "jitter", color = "Questions", palette =c("#00AFBB", "#E7B800", "#FC4E07","#FC3E09"))
 bxp2
 
 p2 <- ggpar(bxp2, 
             title = "Boxplot Comparing Happy Ratings Across All Time Points",
             caption = "Source: ggpubr",
             xlab ="Time Points", 
             ylab = "Happy Ratings",
             legend.title = "Time Points Measured (Pre and Post)")
 p2
 
 #Computation 1 - anova
 
 res.aov <- anova_test(data = df_long_2, dv = Happy_Ratings, wid = pMail, within = Questions)
 get_anova_table(res.aov)
 
 #Computation 2 - pair-wise comparison - t-test
 
 # pairwise comparisons
 pwc <- df_long_2 %>%
   pairwise_t_test(
     Happy_Ratings ~ Questions, paired = TRUE,
     p.adjust.method = "bonferroni"
   )%>%
   pwc
 write_csv("pair-wise_happy_summary_output.csv")
 #Interpretation : Pair-wise difference btw time points were statistically significant
 #different as (p<=0.005)
 
 #----------------------------------------------------------------------------
 
 anova_test_angry = read.csv(file = 'ANOVA_test_angry.csv', header = TRUE)
 head(anova_test_angry)
 
 class(anova_test_angry)# check if data frame else convert to data.table
 
 setDT(anova_test_angry) # this is to convert anova_test_angry data frame to a data table
 
 df_long_3 <- melt(data = anova_test_angry, 
                   id.vars = c("pMail"),
                   variable.name = "Questions",
                   value.name = "Angry_Ratings")
 df_long_3
 
 write.table(df_long_3, "anova_angry_long.csv", row.names=FALSE, sep=",")
 
 df_long_3 %>%
   group_by(Questions) %>%
   get_summary_stats(Angry_Ratings, type = "mean_sd")%>%
   write_csv("anova_angry_summary_output.csv")
 #interpretation : mean of 12c and 13c is 1.53 and 1.28 14c is 1.25
 
 #checking for outliers
 df_long_3 %>%
   group_by(Questions) %>%
   identify_outliers(Angry_Ratings)
 #interpretation 1 : 63 mild outliers and a couple of extreme outliers - 
 #anger is an emotion that can be lessened by listening to any genre of music, specifically 
 # happy and energetic songs as typied by respondents who were quite angry before the 
 #start of our experiment
 #interpretation 2- listening to energetic and high tempo songs can invoke angry 
 #feelings in participants when they were generally in a neutral state to start off with. 
 # This could be characterized by high tempo in music as compared to sad and happy songs where the features are not so upbeat
 
 # Check for normality thru shapiro test and qq plot. As sample size is > 50,
 #use qqplot, but the points do not exactly fall on reference point for each time point
 df_long_3 %>%
   group_by(Questions) %>%
   shapiro_test(Angry_Ratings)
 
 ggqqplot(df_long_3, "Angry_Ratings", facet.by = "Questions")
 
 bxp3 <- ggboxplot(df_long_3, x = "Questions", y = "Angry_Ratings", add = "jitter", color = "Questions", palette =c("#00AFBB", "#E7B800", "#FC4E07","#FC3E09"))
 bxp3
 
 p3 <- ggpar(bxp3, 
             title = "Boxplot Comparing Angry Ratings Across All Time Points",
             caption = "Source: ggpubr",
             xlab ="Time Points", 
             ylab = "Angry Ratings",
             legend.title = "Time Points Measured (Pre and Post)")
 p3
 
 #Computation 1 - anova
 
 res.aov <- anova_test(data = df_long_3, dv = Angry_Ratings, wid = pMail, within = Questions)
 get_anova_table(res.aov)
 
 #Computation 2 - pair-wise comparison - t-test
 
 # pairwise comparisons
 pwc <- df_long_3 %>%
   pairwise_t_test(
     Angry_Ratings ~ Questions, paired = TRUE,
     p.adjust.method = "bonferroni"
   )%>%
   pwc
 write_csv("pair-wise_angry_summary_output.csv")
 #Interpretation : Pair-wise difference btw time points were statistically significant
 #different as (p<=0.005)
 
 #-----------------------------------------------------------------------------
 
 anova_test_fearful = read.csv(file = 'ANOVA_test_fearful.csv', header = TRUE)
 head(anova_test_fearful)
 
 class(anova_test_fearful)# check if data frame else convert to data.table
 
 setDT(anova_test_fearful) # this is to convert anova_test_angry data frame to a data table
 
 df_long_4 <- melt(data = anova_test_fearful, 
                   id.vars = c("pMail"),
                   variable.name = "Questions",
                   value.name = "Fearful_Ratings")
 df_long_4
 
 write.table(df_long_4, "anova_fearful_long.csv", row.names=FALSE, sep=",")
 
 df_long_4 %>%
   group_by(Questions) %>%
   get_summary_stats(Fearful_Ratings, type = "mean_sd")%>%
   write_csv("anova_fearful_summary_output.csv")
 #interpretation : mean of 12d and 13d is 1.13 and 1, 14d is 0.773 and 15d is 0.85
 
 
 #checking for outliers
 df_long_4 %>%
   group_by(Questions) %>%
   identify_outliers(Fearful_Ratings)
 #there are some mild and extreme outliers - total of 36
 #those who were already feeling fearful before the start of experiment actually
 #felt more or same level of fearfulness post listening to the first song which 
 # is a sad one. 
 #happy and energetic songs had the  effect of calming their fearfulness
 
 
 # Check for normality thru shapiro test and qq plot. As sample size is > 50,
 #use qqplot, but the points do not exactly fall on reference point for each time point
 df_long_4 %>%
   group_by(Questions) %>%
   shapiro_test(Fearful_Ratings)
 
 ggqqplot(df_long_4, "Fearful_Ratings", facet.by = "Questions")
 
 bxp4 <- ggboxplot(df_long_4, x = "Questions", y = "Fearful_Ratings", add = "jitter", color = "Questions", palette =c("#00AFBB", "#E7B800", "#FC4E07","#FC3E09"))
 bxp4
 
 p4 <- ggpar(bxp4, 
             title = "Boxplot Comparing Fearful Ratings Across All Time Points",
             caption = "Source: ggpubr",
             xlab ="Time Points", 
             ylab = "Fearful Ratings",
             legend.title = "Time Points Measured (Pre and Post)")
 p4
 
 #Computation 1 - anova
 
 res.aov <- anova_test(data = df_long_4, dv = Fearful_Ratings, wid = pMail, within = Questions)
 get_anova_table(res.aov)
 
 #Computation 2 - pair-wise comparison - t-test
 
 # pairwise comparisons
 pwc <- df_long_4 %>%
   pairwise_t_test(
     Fearful_Ratings ~ Questions, paired = TRUE,
     p.adjust.method = "bonferroni"
   )%>%
 pwc
 write_csv("pair-wise_fearful_summary_output.csv")
 #Interpretation : Pair-wise difference btw time points were statistically significant
 #different as (p<=0.005)
 
 #-----------------------------------------------------------------------------------
 
