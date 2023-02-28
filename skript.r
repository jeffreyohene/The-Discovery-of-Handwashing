#libraries
library(tidyverse)

#data
yearly <- read_csv('datasets/yearly_deaths_by_clinic.csv')

yearly

#yearly death rate of women giving birth
yearly <- yearly %>%
            mutate(proportion_deaths = deaths/births)

yearly

# deaths @ cliniv 1 v clinic 2
ggplot(yearly, aes(year, proportion_deaths, color = clinic)) +
  geom_line()


# After handwashing: clinic 1
monthly <- read_csv('datasets/monthly_deaths.csv')

monthly <- monthly %>%
             mutate(proportion_deaths = deaths/births)         

head(monthly)  

#plotting deaths over time
ggplot(monthly, aes(date, proportion_deaths)) +
  geom_line() +
    xlab('Date') +
      ylab('Death_rate')

# mandatory handwashing start
# From this date handwashing was made mandatory
handwashing_start = as.Date('1847-06-01')

# TRUE/FALSE column being added to monthly called handwashing_started to indicate 
#when mandatory handwashing was enforced.
monthly <- monthly %>%
             mutate(
                 handwashing_started =  date >= handwashing_start
             )

monthly

ggplot(monthly, aes(date, proportion_deaths, color = handwashing_started)) +
  geom_line() +
    xlab('Date') +
      ylab('Death_rate')    


# Calculating the average proportion of deaths 
# before and after handwashing.

monthly_summary <- monthly %>%
                     group_by(handwashing_started) %>%
                       summarize(mean(proportion_deaths))

monthly_summary

# Calculating a 95% Confidence intrerval using t.test 
test_result <- t.test(proportion_deaths ~ handwashing_started, data = monthly)
test_result

# The data Semmelweis collected points to that:
doctors_should_wash_their_hands <- TRUE