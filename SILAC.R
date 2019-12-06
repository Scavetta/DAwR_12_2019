# SILAC Analysis of Myocardial Cells
# Rick Scavetta
# 05.12.2019

# Clear the workspace
rm(list = ls())

# load packages
library(tidyverse)

# Exercise 8.1 (Import and Examine) ----
protein.df <- read.delim("Protein.txt")

names(protein.df)
summary(protein.df)
# str(protein.df)
glimpse(protein.df)

# Convert to a tibble
protein.df <- as_tibble(protein.df)

# This changes the attributes
class(protein.df)

# Which means that we get a nicer print out:
protein.df

# Exercise 9.1 (Remove contaminants)
protein.df %>% 
  filter(Contaminant == "+") %>% 
  count()
# Alternatively:
sum(protein.df$Contaminant == "+")
sum(protein.df$Contaminant == "+")/nrow(protein.df)

# Remove contaminants:
protein.df %>% 
  filter(Contaminant != "+") -> protein.df

# Exercise 8.2 (Clean-up and Transform) ----

# log10 of intensities
protein.df$Intensity.H <- log10(protein.df$Intensity.H)
protein.df$Intensity.M <- log10(protein.df$Intensity.M)
protein.df$Intensity.L <- log10(protein.df$Intensity.L)

# Add intensities H+M, M+L
protein.df$Intensity.H.M <- protein.df$Intensity.H + protein.df$Intensity.M
protein.df$Intensity.M.L <- protein.df$Intensity.M + protein.df$Intensity.L

# log2 of ratios
protein.df$Ratio.H.M <- log2(protein.df$Ratio.H.M)
protein.df$Ratio.M.L <- log2(protein.df$Ratio.M.L)

# Exercise 10.1 (Find protein values)
# GOGA7
# PSA6
# S10AB

# H/M, M/L
# Solutions to deal with _MOUSE:
# 1 - Add _MOUSE to query
# 2 - Remove _MOUSE to search space
# 3 - Use pattern matching
protein.df[protein.df$Uniprot == "GOGA7_MOUSE", c("Uniprot", "Ratio.H.M", "Ratio.M.L")]

protein.df %>% 
  filter(Uniprot == "GOGA7_MOUSE") %>% 
  select(Uniprot, Ratio.H.M, Ratio.M.L)

# Exercise 10.2 (Find significant hits)

# Exercise 10.3 (Find extreme values)

# Exercise 10.4 (Find top 20 values) see section 10.5 Ordering functions
# the 20 highest log2 H/M and M/L ratios
protein.df %>% 
  arrange(-Ratio.H.M) %>% 
  slice(1:20)

protein.df %>% 
  top_n(20, Ratio.H.M) -> topHM

protein.df %>% 
  top_n(20, Ratio.M.L) -> topML


# Exercise 10.5 (Find intersections) see section 10.6 Intersection functions
intersect(topML, topHM)













