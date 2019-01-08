wine = read.csv(file.path("../data", "wine.csv"))
# Kicking out 36 wines with missing values
wine = na.omit(wine)
# Not sure if there is some order to it
set.seed(42)
wine = wine[sample(1:nrow(wine)),]
n = nrow(wine)
