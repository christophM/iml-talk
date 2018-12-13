---
title: "Interpretable Machine Learning"
author: "Christoph Molnar"
date: "2018-12-14"
output:
  ioslides_presentation:
    css: ../styles.css
---

## Machine Learning vs Programing {.center data-background=../images/programing-ml.png data-background-size=contain}


## Machine Learning vs Statistics  {.emphasizedabit}

linear $\Rightarrow$ non-linear

additive $\Rightarrow$ interactions

theory-driven $\Rightarrow$ optimization-driven

## Black Box Problem

![](../images/iml-ml.png)


## {.center data-background=../images/explain.png data-background-size=contain}

## Example: Predict Rent {.center data-background=../images/rent-ml.png data-background-size=contain}

## Feature Effect {.center data-background=../images/pdp-rent.png data-background-size=contain}


## Feature Effect: Partial Dependence Plot

![](../images/pdp.gif)


## Feature Importance {.center data-background=../images/feature-importance-rent.png data-background-size=contain}

## Permutation Feature Importance {.center data-background=../images/permimp-shuffle.png data-background-size=contain}

## Counterfactual Explanations {.center data-background=../images/rent.png data-background-size=contain}

## Shapley Value {.center data-background=../images/shapley-rent.png data-background-size=contain}

## Intepretable Model: Linear Regression {.center data-background=../images/lm.png data-background-size=contain}

## Intepretable Model: Decision Tree {.center data-background=../images/tree.png data-background-size=contain}

## Interpretable Model: Decision Rules {.emphasizedabit}

IF $90m^2\leq \text{size} < 110m^2$  AND location $=$ "good" THEN rent is between 1540 and 1890 EUR

## Global Surrogate {.center data-background=../images/global-surrogate.png data-background-size=contain}

## Local Surrogate {.center data-background=../images/local-surrogate.png data-background-size=contain}



# Causality?

## Machine Learning Model  {.center data-background=../images/graph.png data-background-size=contain}


## Only Association

Without further assumptions for the model, the presented interpretability techniques only have rung one on Pearl's causality ladder (for real world ).

- Rung 1: Association
- Rung 2: Intervention
- Rung 3: Counterfactual


## Some thoughts on causality

- do-calculus for non-linear models?
- PDP shows causal feature effects (intervention) if ML model is causal
- Correlation problematic for permutation importance / PDP / ... $\Rightarrow$ causal models the solution?

<!--
## Example

- ML model predicts shoe size
- Features height and weight correlated (height causal for weight)
- We analyse model effect / importance of height on shoe size
- Involves creating unrealistic people (2m, 50kg)
- Weight is not changed based on height
- Always measures direct effect, but not total (bc. excludes indirect effect)
- Model not causal DAG

-->

## Further readings   
More on interpretable machine learning in my book [http://christophm.github.io/interpretable-ml-book/](http://christophm.github.io/interpretable-ml-book/).

<img src="../images/cover-bordered.jpg" width=300/>
