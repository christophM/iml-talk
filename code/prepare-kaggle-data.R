## Prepare survey data
library('dplyr')
data.dir = 'data/'

survey.raw = read.csv(sprintf('%smultipleChoiceResponses.csv', data.dir), na.strings = c('NA', '-1', '-99', ''))
exchange = read.csv(sprintf('%sconversionRates.csv', data.dir), row.names = 1)
survey = survey.raw

survey = filter(survey, CompensationCurrency %in% c('EUR', 'USE'))

usd.to.eur = 1/exchange[exchange$originCountry == 'EUR','exchangeRate']
# Choose variables of interest
# GenderSelect, Country, Age, EmploymentStatus, StudentStatus, 
# CodeWriter, CareerSwitsche, CurrentJobTitleSelect, TitleFit, 
survey$CompensationAmount = as.numeric(as.character(survey$CompensationAmount))

survey = left_join(survey, exchange, by = c('CompensationCurrency' = 'originCountry'))
survey$CompensationAmount = usd.to.eur * survey$CompensationAmount * survey$exchangeRate
survey$CompensationCurrency = NULL
survey$exchangeRate = NULL


## Fix country
source('code/countries-to-continents.R')
survey$Country = as.character(survey$Country)
survey$Country[survey$Country == "People 's Republic of China"] <- "People's Republic of China"
survey$Country[survey$Country == "Republic of China"] <- "People's Republic of China"
survey$Continent <- Countries.Continents$Continent[match(survey$Country,
                                                              Countries.Continents$Country)]
survey$Continent = droplevels(as.factor(survey$Continent))

## Remove missing and exorbitant salaries
survey = filter(survey, !is.na(CompensationAmount) & CompensationAmount < 200000)

## Choose some variables 
# GenderSelect:  Select your gender identity. - Selected Choice	
# Country: Select the country you currently live in.	
# Age: What's your age?	
# EmploymentStatus: What's your current employment status?	
# LanguageRecommendationSelect: What programming language would you recommend a new data scientist learn first? (Select one option) - Selected Choice	
# LearningDataScienceTime: How long have you been learning data science?	
# Tenure: How long have you been writing code to analyze data?	
# FormalEducation: Which level of formal education have you attained?	
mean.missing = lapply(survey, function(x) mean(is.na(x)))
mean.missing[mean.missing < 0.1]
survey$EmploymentStatus = droplevels(survey$EmploymentStatus)
survey = select(survey, GenderSelect, Continent, Age, EmploymentStatus, CurrentJobTitleSelect, TitleFit, 
                CompensationAmount, LanguageRecommendationSelect, LearningDataScienceTime,
                FormalEducation, Tenure)

nunique = function(x){length(unique(x))}
lapply(survey, nunique)
survey.imp = impute(survey, classes = list(integer = imputeMean(), factor = imputeMode()))
survey.dat = survey.imp$data

# 
# pdp1 = generatePartialDependenceData(mod, task, features = c('GenderSelect'))
# ggplot(pdp1$data) + geom_point(aes(x = GenderSelect, y = CompensationAmount), stat='identity') + scale_y_continuous(limits = c(0, NA))
# 
# 



