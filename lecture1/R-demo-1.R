#' # LECTURE 1: R BASICS

#' ## PART 1: arithmetic and linear algebra

#' ### Basic math
2+2
3*4
1/3  # R as standard has more digits than it shows
print(1/3, digits = 12)
pi
sqrt(2)

#' Saving the results
a <- 34+45  # can also use = instead of <-
a

#' ### Vectors
c(1, 5, -4) # c means concatenate
v <- c(2, 3, -5); v  # several commands on one line is separated with semi-colon 
w <- 1:3; w  # colon is used for sequences of numbers
w <- seq(1, 5, by = 2) # `seq` is used for more general regular sequences
v+w  # adding vectors
v[2]  # extracting element 2 of v
v[2:3] # extracting element 2 and 3 of v
c(v, w) # easy to join vectors into a long vector

#' ### Matrices
A <- matrix(1:9, 3, 3); A  # written by column
B <- matrix(1:9, 3, 3, byrow=TRUE); B  # written by row

#' Extracting elements
A[2,2]  # entry [2,2]
A[,2]  # column 2
A[2,]  # row 2

#' All operations on vectors and matrices are elementswise
A+B  # fine for matrix sum
A*B  # not a proper matrix product - elementwise product
A^{-1}  # not proper matrix inverse - elementwise inverse
exp(A) # again the exponential function is used on each entry

#' proper matrix operations
#+ error=TRUE
A%*%B  # matrix product
solve(A)  # matrix inverse - but this matrix is not invertible
A[3,3] <- 0; A  # changing element at entry [3,3] in matrix
solve(A)  # now it is invertible
A %*% solve(A)  # checking that this really is the inverse (note the slight numerical imprecision)
round(A %*% solve(A))  # looks nicer rounded

#' ### Help
#' All built-in functions have help pages accessible by `?`
?matrix
?exp
?solve
#' If you don't know the name of the command, Google is your friend
#'
#' ### Clean-up (careful: removes everything without asking)
rm(list=ls())  #  Generally don't do this in scripts you pass on to others!!


#' # Exercises for PART 1

#' ## Exercise I
#' a) Make three vectors: `x = (1,1,1,1,1), y = (1,2,3,4,5), z = (1^2,2^2,3^3,4^2,5^2)` 
#' (hint: this is a good place the learn the `rep` command for vectors with
#' repeated numbers or repeated sequences - check the help)
x = rep(1,5) ;x

y = c(1:5) ;y

z = c(1^2 , 2^2 , 3^3 , 4^2 , 5^2) ;z

#' b) Make a matrix `X` with columns `x`, `y`, and `z`.
X = matrix(c(x,y,z),5,3) ;X

#' c) Calculate the matrix $X^T (X^T X)^{-1} X$ (hint: the command `t` is used for transposing)
X %*% solve(t(X) %*% X) %*% t(X)

#' ## Exercise II
#' Try to add two vectors and/or matrices that does not match in dimensions, and see 
#' if you can figure out what R does.
c(1,2) + c(1,2,3,4)

#' ## Exercise III
#' The `solve` command can also be used to solve systems of linear equations. Rewrite
#' $$\begin{aligned}
#'   x - 2y +  z =  0 \\
#'       2y - 8z =  8 \\
#' -4x + 5y + 9z = -9
#' \end{aligned}$$
#' into matrix form, and use `solve()` to solve the system.  
nymatrix = matrix(c(1,0,-4,-2,2,5,1,-8,9),3,3) ;nymatrix
b = c(0,8,-9) ;b
raekkered = solve(nymatrix,b) ;raekkered
nymatrix %*% raekkered

#' # PART 2: data, data summaries, and plotting
#' 
#' Importing data using `scan()` - rather primitive
x <- scan("data1.dat"); x  # note: make sure that you are in the correct working directory

#' ### Data frames
#' Typically we need more something more advanced than a single vector for data - a data frame.
#' Data frames look like matrices and can be used to store data
data.frame(1:4, 5:2, c(1,3,4,7))  # vectors get a column each
data.frame(height = c(178, 182, 171), weight = c(72, 76, 71))  # the columns can be given meaningful names
y <- data.frame(student = c("Allan", "Barney", "Christian"), score = c(34, 36, 43))
y  # can contain letters/words
y[,2]  # same extraction notation as matrices
y$score  # or use $ with column name
names(y)  # names() can be used for checking the content of a complex object that can be extracted with $
str(y) # Gives the structure of any R object. Very useful for complicated objects.

#' importing data using `read.table()`
z <- read.table("data2.dat"); z

### the `class` function is generally useful for figuring out what you are working with
class(z)  # a data frame
class(z$V1)  # a vector
class(z$V2)  # a vector of integers
class(z$V3)  # a factor is a vector of categories - we'll get back to this later
class(z$V4)

#' If we are not satisfied with the class, we may be able to change it
as.character(z$V4)  # changing factor to characters of strings
class(as.character(z$V4))  # now the class has changed
z$V4 <- as.character(z$V4) # saving into data frame
class(z$V4)  # yup - class has changed in the data frame now

#' Other commands: `as.numeric`, `as.vector`, `as.matrix`, `as.character`, `as.factor`, `as.integer`
#' Careful: they don't always do what you expect
a <- c(4,5,6); a
b <- as.factor(a); b
as.numeric(b) # oops - numbers are just the numbers of the categories in some order
as.numeric(as.character(a))  # better

#' there are also `is.xxx` commands for checking
is.numeric(z$V1)
is.numeric(z$V2)  # integers are also numeric
is.numeric(z$V3)

#' R also has many built-in datasets that we can play with
#+ eval=FALSE
library(help = "datasets")  # we'll get back to the library command later

#' let's use cars
head(cars)

#' The datasets also have help pages
#+ eval=FALSE
?cars

#' ### Plotting
#' The generic plot function
plot(cars$speed, cars$dist)
plot(cars$dist ~ cars$speed)  # the same, ~ means "as function of", note different order
plot(cars$speed, cars$dist, pch=3, col="red", type="b")  # many things can be controlled in plot
plot(cars)  # complex objects can also be put into plot - what it does depends on the object
#' Note: `plot` is a generic function, that under the hood dispatches to other functions
#' e.g. `plot.default` or `plot.data.frame`.  
#' Even though you only write `plot(...)` you may still need to look at the help for these other functions
#' 
#' `lines()` and `points()` can be used to add lines and points to an existing plot
plot(cars)
lines(cars$speed, cars$dist) 
points(cars$speed, cars$dist, col="red", pch=5)

#' ### Graphical data summaries
x <- cars$speed; x
y <- cars$dist; y
hist(x)  # histogram
hist(x, breaks=10)  # good for getting an overview of data
boxplot(x)  # boxplot contains 25,50,75 % quantiles, and whiskers
boxplot(c(x, -7, 4, 44))  # changing data a bit - boxplot reveals potential outliers
boxplot(x, y)  # good for comparing data (here it is of course meaningless)

#' ### Numerical data-summaries
mean(x)  # average
median(x)  # median
var(x)  # variance
sd(x)  # standard deviation
range(x)  # range
quantile(x)  # quantiles
summary(x)  # can be used for most objects in R

#' ### Clean-up
rm(list=ls()) 


#' ## Exercises for PART 2

#' ## Exercise I
#' a) Consider the built-in dataset airquality, and find out what it contains.
#' b) Try to plot the whole dataframe, and see what you get.
#' c) Make a scatterplot of the ozone as a function of the temperature.
#' d) Make a nicer plot by adding labels to the x and y axes, and a title on top of the plot.
#' (hint: check the help for plot.default and note that text goes within "")
#' e) Make a plot zoomed in on the x-values 70-80 (hing: same help page).
#' f) Try `plot(airquality$Ozone)`. What does it do? Change the scatter plot to a plot joining the measurements with line segments.
#' (hint: check the argument type in the help page for plot (not plot.default))
#' g) Make a histogram and a boxplot of the Ozone level.
#'
#' ## Exercise II
#' a) Read the data `data3.dat` using `read.table`.
#' (note: this file contains names of each column, so you need to find out how to import headers)
#' b) Make some plots to investigate the data, as well as some non-graphical summaries.
#'
#'
#' ## PART 3: distributions in R


#' R can be used for calculating density functions and distribution functions of most known distributions
dnorm(1, mean=0, sd=1)  # density function for normal dist. with mean 0 and sd 1 evaluated at 1
pnorm(1, mean=0, sd=1)  # Corresponding distribution function

#' let's plot them - the `curve` function is useful for plotting mathematical functions in R
curve(dnorm(x, mean=0, sd=1), from=-5, to=5)  # x must be called x in curve
curve(pnorm(x, mean=0, sd=1), from=-5, to=5)

#' the inverse distribution function (quantile function)
qnorm(0.8, mean=0, sd=1)

#' R can also simulate the distributions
rnorm(5, mean=0, sd=1)  # 5 simulations
hist(rnorm(1000, mean=0, sd=1))  # histogram of 1000 simulations

#' Functions for handling distributions come with the following naming convention:  
#' First part:  
#' `d` = **D**ensity function   
#' `p` = distribution function (cumulative **P**robability)  
#' `q` = inverse distribution function (**Q**uantile)  
#' `r` = simulate (**R**andom number generator)  
#' Last part: distribution name, e.g:  
#' `norm` = normal  
#' `exp` = exponential  
#' `gamma` = gamma  
#' `t` = t  
#' `binom` = binomial  
#' etc.
curve(dgamma(x, shape = 3, rate = 0.5), from=0, to=20)

#' ### Clean-up
rm(list=ls()) 


#' ## Exercises for PART 3

#' ## Exercise I
#' a) Plot the density and distribution function for the t distribution with 3 degree of freedom.
#' b) Make 50 simulations of this t-distribution, and make a histogram. Can you see that this is not a standard normal distribution?
#' (hint: the `curve` command has an argument `add=TRUE` that allows you to add a plot on top of the histogram
#' -- try to add the normal density to the plot; note that this requires the histogram to integrate to one, which can be achieved by
#' including the argument `probability=TRUE` to the `hist` command)
#' c) Repeat exercise b with 10 degrees of freedom - can you still see that this is not a standard normal distribution?
#'
#' ## Exercise II
#' a) The uniform distribution can be simulated using `runif()` - try it out.
#' b) In your probability course you have probably learned how to simulate random variables using the inversion method (i.e. taking
#' the inverse cumulative distribution funciton of the wanted distribution, and evaluating this at a uniform random value). 
#' For the exponential distribution this is done by calculating -log(1-U)/lambda, where U is a uniform random variable and lambda 
#' is the rate parameters of the exponential distribution. Use this for simulating a number of exponential random variables.
