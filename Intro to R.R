# Intro to R
# Rick Scavetta
# 04.12.2019
# Data Analysis with R workshop for ...

# Clear the workspace
rm(list = ls())

# load package
# First, install (only once!)
library(tidyverse)

# Basic R syntax
n <- log2(8) # the log 2 of 8
# <- is the "assign" operator
# you can also use =, but try to avoid this
n # print n to the screen

# A simple workflow ----
# with a built-in dataset
PlantGrowth

# Explore the data set:

# 1 - Summary statistics
# Global mean of ALL weights
mean(PlantGrowth$weight)

# Group-wise means
# %>% the "pipe" operator
# say "... and then ..."
PlantGrowth %>% 
  group_by(group) %>% 
  summarise(avg = mean(weight),
            stdev = sd(weight),
            n_obs = n())

# 2 - Data visualizations
# 3 Essential layers to a plot
# 1 - the data
# 2 - Aesthetic mappings - which variable to MAP onto which scale/axis
# e.g. x, y, color, shape, size, ...
# 3 - Geometry - How the plot will look

# Dotplot
ggplot(PlantGrowth, aes(group, weight, )) +
  geom_jitter(width = 0.2, alpha = 0.6, col = "red")

# Boxplot
ggplot(PlantGrowth, aes(group, weight)) +
  geom_boxplot()

# An example of color as an aesthetic
mtcars # built-in data set about car engines
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(alpha = 0.6)

# 3 - Hypothesis testing
# t-tests:
# for t-tests typically use t.test() function
# but here, we have three groups and multiple tests
# so here, begin by making a linear model:
Plant_lm <- lm(weight ~ group, data = PlantGrowth)

# Summary() will actually give all the t-tests:
summary(Plant_lm)

# 1-way ANOVA
anova(Plant_lm)

# Element 2: Functions ----
# Anything that happens is because of a function
# i.e. verbs

# Arithmetic operators
# Follow "order of operations"
# BEDMAS - Brackets, Expon, Div, Mult, Add, Sub

# These are different:
2 - 3/4 # 1.25
(2 - 3)/4 # -0.25

# This is a function
34 + 6
# and we can write it in the standard way:
`+`(34, 6)

# make some new objects to work with
n <- 34
p <- 6
typeof(p)
# These operate just like integers
n + p

# What are functions?
# Generic form:
# fun_name(fun_arg1 = ..., fun_arg2 = ...)

# Functions take many forms!
# 1 - Call args by name or positional matching
log2(8) # short form, positional matching
log2(x = 8) # short form, naming
log(x = 8, base = 2) # long form, naming
log(8, 2) # long form, positional matching
log(8, base = 2) # combination positional matching and naming
log(2, x = 8) # confusing!

# 2 - Call args by partial name matching
log(8, b = 2) # partial name matching

# 3 - Funs can have 0 to many uncountable args
# e.g. 0 args
# geom_boxplot()
# n()
# ls()

# 4 - args can be named or unnamed
# e.g. uncountable and unnamed args
# combine
xx <- c(3, 8, 9, 23)
xx

myNames <- c("healthy", "tissue", "quantity")
myNames

# Build a sequence with seq()
seq(from = 1, to = 100, by = 7)

foo1 <- seq(1, 100, 7)
foo1

# Recall we can also use objects that equate to integers
foo2 <- seq(1, n, p)
foo2

# shortcut for a inverval 1 sequence, the : operator "colon"
1:10
seq(1, 10, 1)

# repeat values with rep()
rep(c("A", "B"), 2) # "A" "B" "A" "B"
rep(c("A", "B"), each = 2) # "A" "A" "B" "B"

# some other useful functions:
length(foo1)
range(foo1)

# Math functions ----
# Two broad classes
# 1 - Aggregration functions - 1 value as output
# median, std dev, mean, max, etc ...

# 2 - Transformation functions - same number of output as input
# standardization, log, z-scores, +, -, /, etc ...

# e.g.
foo2 + 100 # transformation
34 + 6 # transformation
foo2 + foo2 # transformation
sum(foo2) + foo2 # agg followed by trans
1:3 + foo2 # trans

# FUNDAMENTAL CONCEPT: VECTOR RECYCLING

1:4 + foo2

# 3 kinds of messages:
# Information - neutral
# Warning - maybe something went wrong, check it out
# Error - Full stop :/

# Element 3: Objects ----
# Anything that exists is an object
# i.e. Nouns

# 3 most common data storage objects
# vectors, lists and data frames

# Vectors - 1-dimensional, homogenous data type
xx
foo1 # 15-element long numeric vector
foo2
myNames # 3-element long character vector
n # 1-element long numeric vector
p

# 4 most common Atomic vector types
# logical - TRUE/FALSE, T/F, 1/0 (aka Boolean, binary)
# integer - whole numbers [-Inf, Inf]
# double - real numbers (aka float) [-Inf, Inf]
# character - Everything (aka strings)

# numeric - generic reference to integer or double

# examine the type
typeof(foo2)

foo3 <- c("Liver", "Brain", "Testes", "Muscle", "Intestine", "Heart")
typeof(foo3)

foo4 <- c(TRUE, FALSE, FALSE, TRUE, TRUE, FALSE)
typeof(foo4)

# Atomic vector type hierarchy and coercion
test <- c(1:10, "bob")
test
typeof(test)
# can't do math on character
mean(test) # wrong type from a contaminating character

# solution: Coercion with an as.*()
# where * is numeric, integer, double, etc...

# coerce and update the vector:
test <- as.numeric(test)

# now you can do math, remove NAs:
mean(test, na.rm = TRUE)

# FUNDAMENTAL PROBLEM - WRONG TYPE!

# Lists - 1-dimensional, heterogenous data types
# e.g.
Plant_lm

length(Plant_lm)

# look at attributes (metadata)
attributes(Plant_lm)

# the names attribute
# each element gets a name
# access with the "accessor" function
names(Plant_lm)

# Access any named element with $ notation
Plant_lm$coefficients
Plant_lm$residuals
Plant_lm$model

# the class attribute
# access with the "accessor" function
typeof(Plant_lm)
class(Plant_lm)
# classes tell other functions in R 
# how to handle this object

# e.g. that's why this gives the t-tests:
summary(Plant_lm)
# contrast to:
summary(PlantGrowth)

# What's the class of PlantGrowth?
class(PlantGrowth)
typeof(PlantGrowth)

# data frames - 2-dimensional, heterogenous
# A data frame is a special class of type list
# where each element is a vector of the same length
# i.e.:
# rows = observations
# columns = variables

names(PlantGrowth)
dim(PlantGrowth) # rows, columns
nrow(PlantGrowth)
ncol(PlantGrowth)

foo.df <- data.frame(foo4, foo3, foo2)
foo.df

# some first things to do:
summary(foo.df)
str(foo.df) # "structure"
glimpse(foo.df) # from dplyr, part of the tidyverse

# dim versus length
dim(foo.df)
length(foo.df) # The number of elements in the list

# access and change names:
names(foo.df) <- myNames
foo.df$healthy

# Element 4: Logical Expressions ----
# Asking and combining TRUE/FALSE questions
# Relational operators for ASKING questions
# == equivalency
# != non-equivalency
# >, < >=, <=
# !x the negation of x, where x is a logical vector

# Logical operators for COMBINING questions
# & AND - must be TRUE in EVERY question
# | OR - must be TRUE in AT LEAST one question
# %in% WITHIN - combine many == with |

# you will ALWAYS get a logical vector as a result

# Use filter to extract rows that match TRUE

# For logical data
# All healthy observations
foo.df %>%
  filter(healthy)

# All unhealthy observations
foo.df %>% 
  filter(!healthy)

# For numeric data
# below quantity of 10
foo.df %>% 
  filter(quantity < 10)

# What actually happened?
foo.df$quantity < 10

# between quantity 10 and 20 (i.e. middle)
foo.df %>% 
  filter(quantity > 10 & quantity < 20)
# alternatively...
foo.df %>% 
  filter(quantity > 10, quantity < 20)

# Meaningless
foo.df %>% 
  filter(quantity > 10 | quantity < 20)

# beyond quantity 10 and 20 (i.e. the tails)
foo.df %>% 
  filter(quantity < 10 | quantity > 20)

# impossible
foo.df %>% 
  filter(quantity < 10 & quantity > 20)

# For character data
# NO pattern matching
# All heart samples
foo.df %>% 
  filter(tissue == "Heart")

# Only heart and liver samples
# ok, but inefficient
foo.df %>% 
  filter(tissue == "Heart" | tissue == "Liver")

# Using a vector
# NEVER do this!
foo.df %>% 
  filter(tissue == c("Heart", "Liver"))
foo.df %>% 
  filter(tissue == c("Liver", "Heart"))
# Because of vector recycling!!!

# The correct way:
foo.df %>% 
  filter(tissue %in% c("Heart", "Liver"))
foo.df %>% 
  filter(tissue %in% c("Liver", "Heart"))

# tail ends and healthy:
foo.df %>% 
  filter((quantity < 10 | quantity > 20), healthy == TRUE)

# Element 5: Indexing ----
# Finding information by position using []

# Vectors - 1-dimensional
foo1
foo1[6] # the 6th value
foo1[p] # the pth value
foo1[length(foo1)] # the last value
foo1[3:p] # the 3rd to the pth value
foo1[p:length(foo1)] # the pth to the last value

# We can use any combination of integers, or
# objects or functions that equate to integers

# BUT... The exciting part is using LOGICAL VECTORS!
# i.e. the result of functions or logical expressions

foo1[foo1 < 50] # all values below 50

# data frames - 2-dimensional
# specify [ <rows> , <columns> ]
foo.df[3,] # All columns, 3rd row
foo.df[,3] # All rows, 3rd column

foo.df[3:p, 3 ] # 3rd to the pth row, only quantity
foo.df[3:p, "quantity"] # 3rd to the pth row, only quantity

foo.df[foo.df$quantity < 10, "tissue"] # tissues with quantity below 10

# Note that this is the same as:
foo.df %>% 
  filter(quantity < 10) %>% 
  select(tissue)

# Element 6: Factor Variables
