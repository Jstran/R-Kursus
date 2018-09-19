#' ---
#' title: "LECTURE 2"
#' author: "Ege Rubak (based on Jakob G. Rasmussen's material)"
#' date: ""
#' output:
#'   html_document: default
#'   pdf_document: default
#' ---
#'
#' ## PART 1: packages and programming
#'
#' If R does not contain the functions/statistics you need, odds are that somebody has implemented it in a package.
#' Installing a package - here a package for handling the multivariate normal distribution
#+ eval=FALSE
install.packages("mvtnorm")  # only need to install it once

#' ### Loading a package
library(mvtnorm)  # need to do this everytime R is started

#' In Rstudio you can also use the Packages Window to the right.
#'
#' Now the following functions work for calculating the density of and simulating multivariate normal distributions
dmvnorm(c(1,2,2), mean = rep(0,3), sigma = diag(3))  # evaluating the 3-dim standard normal density
rmvnorm(5, mean = rep(0,3), sigma = diag(3)) # every row is a simulation

#' If you don't know what a package contains, you can try
#+ eval=FALSE
library(help = "mvtnorm")

#' Another useful package - rmarkdown - used to make reports/slides with text/math/R-output fast
# install.packages("rmarkdown")  # takes a minute or so, so I won't run it now

#' It is possible to use a function from a package with out loading the package
#' first via `library`. This is done using the :: notation like this:
#+ eval=FALSE
rmarkdown::render("markdown_example.Rmd")

#' There are thousands of other packages for specific needs.
#' 
#' Google is a good way of finding out whether there is a package that suits your need.
#' You can also make packages yourself, but we won't go into this.

#' If there is nothing premade in R or any packages, you will need to program it yourself.
#'
#' ### For-loop
#' Calculating 1+2+...+10 as an example
s = 0
for (i in 1:10){
  s = s + i
}  # any vector can be used instead of 1:10
s
#' Calculating the first ten Fibonacci numbers
f = rep(0,10)
f[1] = f[2] = 1
for (i in 3:10){
  f[i] = f[i-2]+f[i-1]
}
f
#' Note that built-in functions are usually faster than for-loops created from scratch
#'
#' ### If-then-else conditions
#' Determining the sign of a number
x = -3
if (x<0) {
  signx = -1 
} else{
  if (x==0){
    signx = 0
  } else{
    signx = 1
  }
}
signx

#' ### Functions
#' A function for finding the sign of a number
signfct = function(x){  # notation: output = function(input1,input2,...){blablabla}
  signx <- 0 # Assume 0 until found otherwise
  if (x<0) {
    signx <- -1 
  }
  if (x>0){
    signx <- 1
  }
  return(signx)
}
signfct(-3);signfct(0);signfct(0.2)
#' There is a built-in function `sign`
sign(-3);sign(0);sign(0.2)
sign(-3:4)  # this will even take vectors or matrices
signfct(-3:4)  # our function is not that smart, due to the if-condition only accepting a single term
#' Morale: always think about all the types of input you would like to have and try them out.
#'
#' ## PART 1 exercises
#'
#' I) Make a function with a for loop that can calculate the product of all the entries in an input vector.
#' Compare with the built-in function `prod` (don't call your function prod, or you won't be able to use the built-in function easily).
vecProd <- function(x){
  product <- x[1]
  for (i in 2:length(x)){product <- product * x[i]}
  return(product)
}
vecProd(c(2,3,4))

#' II) Make a function that will calculate the Fibonacci number up to n (an input parameter).
#'     - Does it handle n=1 or 2 correctly? (hint: an `if` statement may be useful here)
#'     - Does it handle negative numbers correctly? (hint: the `stop` function can be used to give an error message)
#'     - Does it handle decimal numbers correctly?
#'
#' III) Install and load the package `ggplot2` for creating nice plots in R.
#' Look at the package help and experiment a bit. To get an idea of the possibilities
#' search for ggplot2 at <https://images.google.com>.
#' This package is part of a collection of packages called the `tidyverse` which
#' are very powerful for data manipulation and graphics.
#'
#'
#' ## PART 2: overview of statistical analysis, linear models, and regression


#' ### We will use the lecture slides (made with rmarkdown) for this part.


#' ## PART 2 exercises

#' I) Consider the built-in dataset `cars`
#'     a) Make the design matrix X for a simple linear regression for `cars` (`dist` as a function of `speed`).
#'     b) Estimate beta. Plot the data and the estimated line in the same figure. 
#'     (hint: the function `abline` is useful for plotting the line)
#'     c) Estimate sigma^2.

#' II) Maybe a second order polynomial is better at capturing the relation between speed and distance?
#' Redo exercise I with a second order polynomial. (Hint: `curve` may be useful)
#'
#' III) Consider the dataset `trees`
#'     a) Make the design matrix for a multiple regression model for modelling the tree volume as a function 
#'     of girth and height.
#'     b) Estimate the vector of coefficients beta and the variance sigma^2.
#' 
#'
#' ## PART 3: the lm-function and ANOVA kind of models


#' Obviously linear models are implemented in R - we use the `lm` function
mod1 <- lm(dist ~ speed, data = cars); mod1  

#' `y~x` is R formula language for $y = \beta_0 + \beta_1 x + \epsilon$
#' I.e. ignore the constand term, the parameters, and the error term.
#' If we don't want the constant term, we can write y~-1+x

#' The `lm` function creates an lm-class object with lots of content
class(mod1)
names(mod1)
summary(mod1)  # the estimate for beta and sigma can be found here


#' ### Plotting the estimated model
beta_hat1 = coef(mod1); beta_hat1 # we extract the estimates of beta into a vector (with names)
plot(dist ~ speed, data = cars)
abline(beta_hat1)

#' ### Functions of the x-variables
#' If we want the second order polynomial, we should be careful:
#' `+`, `-`, `*`, `^` have special meanings in the R formula language.
#' If we enclose terms involving these in `I()`, they have their usual meaning
lm(Volume ~ Girth + Height, data = trees) # y = beta0 + beta1*x1 + beta2*x2 + epsilon
lm(Volume ~ I(Girth + Height), data = trees) # y = beta0 + beta1*(x1+x2) + epsilon

#' Second order polynomial used to model `cars`
mod2 = lm(dist ~ speed + I(speed^2), data = cars); mod2
beta_hat2 = coef(mod2)
plot(dist ~ speed, data = cars)
lines(fitted(mod2) ~ speed, data = cars)

#' ### Categorical variables
#' So far we have considered the x variables as continuous/numeric.
#' What if they are categorical, i.e. represent groups?
#' This is considered in the lecture slides and afterwards we continue with the
#' material below.

#' We make a one-way ANOVA to compare different kinds of insect sprays
# ?InsectSprays
head(InsectSprays)
class(InsectSprays$count); class(InsectSprays$spray)
plot(count ~ spray, dat = InsectSprays)
mod3 <- lm(count ~ spray, data = InsectSprays); mod3  # type A is the reference group here
summary(mod3)

#' ### A two-way ANOVA (i.e. two factors)
# ?warpbreaks
head(warpbreaks)
table(warpbreaks[,c("wool", "tension")]) # a quick overview of the number of combinations
plot(breaks ~ wool, data = warpbreaks)  # breaks vs wool type
plot(breaks ~ tension, data = warpbreaks)  # breaks vs tension
lm(breaks ~ wool + tension, data = warpbreaks)  # wool A and tension L are reference groups
lm(breaks ~ wool + tension + wool:tension, data = warpbreaks)  # wool*tension is interaction
#' The model without interaction means that wool and tension have separate additive effects
#' Interaction means that different types of wool have different behavior depending on tension
#'
#' To sum up: there are a lot of different terms that can go into a linear model as x.
#' All types can be combined.
#'
#' ## PART 3 exercises

#' I) Consider the data `ToothGrowth`. The data contains two explanatory variables, 
#' a factor `supp` and a numeric variable `dose` (it only contains 3 different values
#' so it could also be sensible to convert it to a factor of e.g. low, medium and high
#' dose, but we will treat it as numeric here). We start by ignoring the factor `supp`.
#'     a) Plot the data (only `len` and `dose`).
#'     b) Model the relation between `len` and `dose` with a simple linear regression,
#'     and add the estimated line to the plot.
#'     c) Try a second order polynomium, and add the curve to the plot. Does it seem to fit better?
#'     D) And a third order polynomium. What happens here?
#'
#' II) Now ignore `dose` in `ToothGrowth`.
#'     a) Plot the data (`len` vs `supp`).
#'     b) Model the relation with an ANOVA kind of model.
#'     Does it seem that `OJ` or `VC` yields the highest values for len?

#' III) Now all the data.
#'     a) Plot all the data. 
#'     (hint: try to plot `len` vs `dose` with `col=supp` to get different colors for each group)
#'     b) Make a model with both explanantory variable (only use a first order polynomial for dose).
#'     The model has the interpretation that we have different lines depending on the type in `supp`.
#'     They have the same slope (beta_dose).
#'     But different intercepts (beta_intercept or beta_intercept+beta_suppVC).
#'     Add both lines to the plot.
#'     c) Include an interaction term. Interaction between a continuous and categorical variable is simple:
#'     The lines can now have different slopes (beta_intercept or beta_intercept+beta_dose:suppVC)
#'     Include the lines in the plot (you may want to make a new plot).
