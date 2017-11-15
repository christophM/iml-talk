## Prepare survey data
library('dplyr')
data.dir = 'data/'

survey.raw = read.csv(sprintf('%smultipleChoiceResponses.csv', data.dir), na.strings = c('NA', '-1', '-99', ''))
exchange = read.csv(sprintf('%sconversionRates.csv', data.dir), row.names = 1)
survey = survey.raw

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


mean.missing = lapply(survey, function(x) mean(is.na(x)))
mean.missing[mean.missing < 0.1]

survey = select(survey, GenderSelect, Country, Age, EmploymentStatus, CodeWriter, CurrentJobTitleSelect, TitleFit, 
                CompensationAmount)

nunique = function(x){length(unique(x))}
lapply(survey, nunique)


library(mlr)
library('ggplot2')
survey.imp = impute(survey, classes = list(integer = imputeMean(), factor = imputeMode()))
task = makeRegrTask(data = survey.imp$data, target = 'CompensationAmount')

lrn = makeLearner('regr.randomForest')
mod = train(lrn, task)


pdp1 = generatePartialDependenceData(mod, task, features = c('Age'))
plotPartialDependence(pdp1) + scale_y_continuous(limits = c(0, NA))


pdp1 = generatePartialDependenceData(mod, task, features = c('GenderSelect'))
ggplot(pdp1$data) + geom_point(aes(x = GenderSelect, y = CompensationAmount), stat='identity') + scale_y_continuous(limits = c(0, NA))





