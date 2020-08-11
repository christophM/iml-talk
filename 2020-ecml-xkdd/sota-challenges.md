# Interpretable Machine Learning -- State Of the Art and Challenges

## Abstract:
Following the rise of machine learning came the need for interpretability, proofen by a flood of papers, software and blogposts.
Interpretability of models is used for many reasons.
Without interpretability, researchers using ML could not generate knowledge, ML engineers would have a more difficult time debugging.

Interpretable Machine Learning has made its way into many places such as being used for research instead of statistical methods, as part of products such as understanding image classifications.
Also when ML is being used for automation of tasks such as decision making (e.g. is some transaction fraud), explanations can help the case worker understand which parts of the transaction made it fraud like.
In this paper we review the status quo of Interpretable Machine Learning and where its challenges lie.
We argue that great advances came through ideas from other fields such as game theory.
We urge that we learn more from other fields as well for the challenges ahead.


## Introduction

As ML is embedded into many tasks, for all tasks that need more than prediction, we need explainability.
This can be understanding the model for scientific purposes, but also for justification of decisions, for debugging a model and so on.


## A Very Short History of Model Interpretation

When we go back to the roots, I think this would be linear models and decision rules.
Things like cybernetics and expert systems are not of interest here, as we focus on a subset of AI technologies that learn from data, so only machine learning.

Linear models are very old, starting with Gauss and legegegegeg who used it for solar system equations.
qtetetetet then later popularized it for learning from data in the social sciences.

Until 1950s mostly statistical methods available, so I guess we can't speak yet of interpretable machine learning.
A side note: I don't want to distinguish too sharply between statistics and machine learning.
But for this context, I would say in statistical modeling the focus is on finding a suitable linear model using in-sample metrics such as R squared and AIC.
In machine learning we use an external test set to minimize the generalization loss and the model itself does not matter as long as the loss is low.

From 1950s on there is some first research on ML, with an AI winter following in the 1970s.
Again in 1980s / 1990s research picked up for SVMs, neural networks and so on.
Very interesting milestone is random forest in 1995, which comes with some built-in interpretability tools, 1995, and extended and popularized in 2001 by Breiman.
Still used to this day in many sciences such as medicine and psychology.

In 2010s then came the deep learning hype.

The big leap came in the mid 2010's, visible in Google Search trends [link] and Web of Science statistics when searching for 'Explainable AI' and 'Interpretable Machine Learning'.
These figures look like there has not been much research on explaining prediction models before, which would be a wrong conclusion.
Research was done, big time in statistics for regression models in its various extensions, rule based stuff in computer science, random forest and its many extensions and interpretation.
What has changed is that Interpretable Machine Learning or Explainable Artificial Intelligence has become a field that now ties all these topics together.
Especially model-agnostic methods that work for any type of model have grown a lot in this new field.

## Where Do We Stand Today in 2020?

We have software, big companies that offer solutions and many startups.
Research is heavily underway and people are already using the solutions.


## What Methods do We Have?

There are many overview papers with categorizations of all these methods.
Here are the properties I find the most useful to categorize the various methods and allow a user to understand when to use which.

An interesting distinction is how the methods work:
They either explain individual 'parts' of the model, examples are the weights in a linear model, the structure of a tree.
This can be very straightforward such as the interpretation of a linear regression weight, which directly tells us how a feature influences the response.
Or this can be more complex, when we want to understand what the role of individual neurons in a convolutional neural network is.
Here we can do activation maximization which tells us to which image the neuron most strongly reacts to and interpret this neuron as, e.g., a detector of a certain pattern.
Methods that require to look at certain parts of the model are by definition model-specific, i.e. they cannot be applied to any model.
Methods that mostly observe the input - output behavior are often model-agnostic, i.e. they ignore whether the model is a neural network, linear model or random forest.

A second distinction is about whether a method explains an individual data point or the global model behavior.
Methods such as Shapley Values and LIME compute explanations for points, while there are many feature importance methods that quantify the importance of a feature globally for the model, meaning across all data points.

### Linear models

Linear models have been around since 1800s.
The beauty of them is that they are additive, meaning that the influences of each feature on the target can be added together to give the full effect.
That makes estimation and interpretation simple.
But this is often not adequate since in the real world the effects are usually not linear.
Many extensions exists, such as non-linear transformations for the case that the target follows a different distribtuion (GLMs, logistic regression).
Other extensions allow for non-linear effect of a feature, by using splines.
Also interactions can be integrated.
All these extensions make the model more difficult to interpret, but also allow to more flexible model the target.

### Rule-based models

There are different approaches.
They all have in common that they find decision rules in the form of conditions combined with AND conjunctions leading to some prediction if all conditions are matched.
There are different ways to find this rules and if they are allowed to overlap and so on.
Differences in how they are optimized and so on.

### Counterfactual Explanations

Counterfactual explanations are rather simple explanations for individual predictions.
A counterfactual explanation tells you how the features should be changed to get to a different prediction or classification.
But when you look closer at how you find them, it gets more difficult.
There are many tradeoffs to make.
First, you want to get as close as possible to the desired outcome.
At the same time you don't want to change too many features, and the features that are changed should not be changed too much.
Also these changes should not create unrealistic combinations of feature values, think of a 2m person for which the weight was changed to 30kg.
The reason that there are many papers on the topic is that the search for counterfatuals can be expensive.
Some methods are only for specific types of models, and they all trade-off the various objectives in different ways.
We argued that it is necessary to treat this as a multi-objective problem and the result should be not one but many counterfactual explanations.


### LIME

### Shapley Values

### Feature Effects and Importance

### Images heatmaps

## Challenges

### Dependent Features are Tricky

Feature dependence comes in many forms, correlation being the simplest and most known.
When features are dependent -- and they usually are -- disentangling the effect of one from the other are difficult if not impossible.
For example, if you measure various markers of inflammation in a blood sample, they will be highly correlated.
Using these markers in a predictive model for classifying diseases for which these markers are highly predictive, the model can rely on any of them with arbitrary weighting.
Attributing which marker was the most important now becomes difficult.

Almost all interpretation methods are affected by this issue.
Most of them ignore this issue and pretend the features are independent of each other.
For example the permutation feature importance measure quantifies the importance as the drop in performance when the feature is permuted.
But permutation when features are dependent not only breaks the association with the target value, but also with the other features.
Now if we permute one blood marker, it might create new combination that might be very unlikely.
These combinations are now fed to the model to get the predictions, but these are outside of the training data distribution and the model never had to deal with similar combinations.
It is totally unclear how the model will behave and it might even be irrelevant how the model will behave for these data points as they will never occur in real life.
There are attempts to 'fix' this issue, namely to not permute the feature, but to draw from the conditional distribution.
This means we still sample new values, but only the ones that are conforming with the other feature values.
Unfortunately, this is not a simple 'fix' of the issue.
While it solves the extrapolation issue, it becomes a new measure altogether, since conditional feature importance measure the drop in performance "given that we know the other feature values".
This can mean that the two most important features can drop to almost zero importance when yhey are highly correlated.

Similar things happen to 'fixes' for e.g. Shapley Values.
Once we start sampling from the conditional distribution and not from the marginal, we don't get Shapley Values for our original question, but something else.

I fear that there is no easy solution.

### Causality

In general, we are not allowed to make a causal interpretation of machine learning models.
There is an inherent conflict between prediction performance optimization and causal modeling.
A feature might give some additional predictive performance, but its effect may not be interpreted causally, because, e.g., we did not include the confounder of both this feature and the target.
The fact that the ground has some predictive value for tomorrow's weather, but it's not causal for it.
The common confounder is today's weather -- todays rain makes the ground wet.
And if we had no access to todays weather but only to the "wet ground"-feature, we have to decide between predictive performance and causal correct interpretation.

## Conclusion

There are many established methods now for interpreting machine learning methods.
These methods also are implemented now in many software packages.
Big leaps in the field came from old ideas in other fields.
The Shapley Value has been for a long time part of game theory, and its introduction to machine learning interpretability has spurred a lot of development.


We can learn a lot from Statistics and how it handles uncertainty.





