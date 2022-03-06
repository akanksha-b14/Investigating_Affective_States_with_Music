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
survey_demographics = read.csv(file = 'Survey_Demographics.csv', header = TRUE)
head(survey_demographics)

# 2. Table of summary statistics table with `gtsummary`

sumstat3 = 
  survey_demographics %>% 
  select(Age_Range, Gender, Preferred_Language, Listening_Period, Listening_Frequency,Music_Genre, Post_Music_Emotion, Music.Training) %>%
  tbl_summary(
    by = Age_Range,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean} ({sd})", "{median} ({p25}, {p75})" , "{min}, {max}"),
    missing = "no"
  ) %>%
  modify_header(stat_by = md("**{level}**<br>N =  {n} ({style_percent(p)}%)")) %>%
  modify_spanning_header(all_stat_cols() ~ "**Emotional States**") %>%
  add_n() %>%
  add_p() %>%
  bold_labels() %>%
  italicize_levels()

sumtable = as_gt(sumstat3)
sumtable
--------------------------------------------------------------------------


getwd()
# change to desired working directory with all relevant files 
setwd("C:/Users/User/Desktop")
hsongs = read.csv(file = 'song_features_hindi_combined.csv', header = TRUE)
head(hsongs)

# 1. Visualization - Donught

Hsongs_mood  = hsongs %>% count(`mood`)
kable(Hsongs_mood, caption = "Count of Songs By Mood")

mdonut <- data.frame(
  category = Hsongs_mood$`mood`,
  count = Hsongs_mood$n
)

#compute proportions
mdonut$proportions <- mdonut$count/sum(mdonut$count)
mdonut$ymax = cumsum(mdonut$proportions)
mdonut$ymin = c(0, head(mdonut$ymax, n = -1))
mdonut$labelPosition = (mdonut$ymax + mdonut$ymin)/2
mdonut$label = paste0(mdonut$category, "\n", round(mdonut$proportions*100, 1), "%")

# Make the donut chart using ggplot2
pp2 = ggplot(mdonut, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  # x here controls label position (inner / outer)
  geom_text(x=2, aes(y=labelPosition, label=label, color=category), size=4) + 
  scale_fill_brewer(palette=9) +
  scale_color_brewer(palette=6) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none")
# display the chart
pp2





# 2. Table of summary statistics table with `gtsummary`

sumstat3 = 
  hsongs %>% 
  select(danceability, acousticness, energy, instrumentalness, liveness, valence, loudness, speechiness, tempo, mood) %>%
  tbl_summary(
    by = mood,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean} ({sd})", "{median} ({p25}, {p75})" , "{min}, {max}"),
    missing = "no"
  ) %>%
  modify_header(stat_by = md("**{level}**<br>N =  {n} ({style_percent(p)}%)")) %>%
  modify_spanning_header(all_stat_cols() ~ "**Emotional States**") %>%
  add_n() %>%
  add_p() %>%
  bold_labels() %>%
  italicize_levels()

sumtable = as_gt(sumstat3)
sumtable


## 3. Pearson's correlation matrix

# note that Pearson's correlation only applies to continuous numeric data 
hsongs.cont = hsongs %>% 
  select(danceability, acousticness, energy, instrumentalness,liveness, valence, loudness)
# use base R's `cor()` function to produce the matrix
hsongs.corrmat = cor(hsongs.cont)
hsongs.corrmat

# visualize correlation matrix with "corrplot" package
corrplot(hsongs.corrmat, type = "full", order = "hclust", method = "shade",
         tl.col = "black", tl.srt = 45)

#---------------------------------------------------------------------


