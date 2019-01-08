## Prepare survey data
library('dplyr')
library('mlr')

data.dir = '../data/'

survey.raw = read.csv(sprintf('%smultipleChoiceResponses.csv', data.dir), na.strings = c('NA', '-1', '-99', ''))
exchange = read.csv(sprintf('%sconversionRates.csv', data.dir), row.names = 1)
survey = survey.raw

survey = filter(survey, CompensationCurrency %in% c('EUR'))

usd.to.eur = 1/exchange[exchange$originCountry == 'EUR','exchangeRate']
# Choose variables of interest
# GenderSelect, Country, Age, EmploymentStatus, StudentStatus, 
# CodeWriter, CareerSwitsche, CurrentJobTitleSelect, TitleFit, 
survey$CompensationAmount = as.numeric(as.character(survey$CompensationAmount))

survey = left_join(survey, exchange, by = c('CompensationCurrency' = 'originCountry'))
survey$CompensationAmount = usd.to.eur * survey$CompensationAmount * survey$exchangeRate
survey$CompensationCurrency = NULL
survey$exchangeRate = NULL

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
survey = select(survey, Gender=GenderSelect, Age, EmploymentStatus, JobTitle=CurrentJobTitleSelect, 
                CompensationAmount, LanguageRecommendationSelect, EmployerIndustry,
                FormalEducation, Tenure, DataScientist=DataScienceIdentitySelect, MLToolNextYearSelect, LanguageRecommendationSelect)

survey$LanguageRecommendationSelect = droplevels(survey$LanguageRecommendationSelect)
survey$MLToolNextYearSelect = droplevels(survey$MLToolNextYearSelect)


survey$Gender = factor(survey$Gender, levels = c('Female', 'Male', 'A different identity', 
                                              'Non-binary, genderqueer, or gender non-conforming'))

nunique = function(x){length(unique(x))}
lapply(survey, nunique)
survey.imp = impute(survey, classes = list(integer = imputeMean(), factor = imputeMode()))
survey.dat = survey.imp$data



