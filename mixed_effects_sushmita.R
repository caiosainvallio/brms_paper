##############################################################################
#                          Mixed Effects Modeling                            #
#                           Sushmita Shrikanth                               #
##############################################################################



# When to Use? ---------------------------------------------------------------
# Studies that obtain multiple measurements over time (longitudinal, 
# time-series) or multiple trials per participant (within subjects) lend 
# themselves well to mixed model analyses.


# Important terminology ------------------------------------------------------

## Crossed designs -----------------------------------------------------------
# Refer to the within-subject variables (i.e. timepoint, condition, etc.). 
# Crossed designs occur when multiple measurements are associated with multiple
# grouping variables. In a completely crossed design, all subjects provide 
# responses for all conditions/time-points.


## Nested designs ------------------------------------------------------------
# Refer to the between-subject variable. Generally this is a higher-level 
# variable that subjects or items are grouped under.


## Fixed effects (population-level) ------------------------------------------
# Are, essentially, your predictor variables. This is the effect you are 
# interested in after accounting for random variability (hence, fixed).


## Random effects (group-level) ----------------------------------------------
# Are best defined as noise in your data. These are effects that arise from 
# uncontrollable variability within the sample. Subject level variability is 
# often a random effect.


## NOTE ----------------------------------------------------------------------
# Predictor variables can be both fixed (i.e. causing a main effect/interaction)
# and random (i.e. causing variance/variability in responses). When building 
# your models, you can treat your predictor as a fixed & random factor.



## Intercepts ----------------------------------------------------------------
# The baseline relationship between Independent Variables & Dependent Variable.
# Fixed effects are plotted as intercepts to reflect the baseline level of 
# your Dependent Variable.

## Random intercepts: Variability in baseline measurements
## Fixed intercepts: Baseline variance is not affected


## Slope ---------------------------------------------------------------------
# The strength of the relationship between Independent Variables & Dependent
# Variable (controlling for randomness), which represent random effects. 
# You should expect to see differences in the slopes of your random factors.



# Setting up -----------------------------------------------------------------

library (lmerTest) # Mixed model package by Douglas Bates, comes w/ pvalues! 
library (texreg) #Helps us make tables of the mixed models
library (afex) # Easy ANOVA package to compare model fits
library (plyr) # Data manipulator package
library (ggplot2) # GGplot package for visualizing data







# Random effects structure ---------------------------------------------------

## (1 | subject) -------------------------------------------------------------
# Random intercepts and slopes for subjects (different baselines, different 
# average effect per subject).


## (1 + pizza | subject) -----------------------------------------------------
# The effect of pizza will vary between subjects. Random intercepts for pizza 
# consumption, random slopes for subjects influenced by pizza consumption.


## (1 + pizza | subject) + (0 + time | subject) ------------------------------
# Subjects have random intercepts and slopes as influenced by pizza consumption.
# Time slopes can vary as function of the subject, but variance between pizza
# consumption and time as independent


## (1 + pizza + time | subject) ----------------------------------------------
# Same as above, but variance between pizza consumption and time are SHARED 
# (pizza consumption has relationship with time that varies by subject).


## (1 + pizza * time | subject) ----------------------------------------------
# Each subject can have their intercept, random slopes influenced by pizza 
# and time, and their interaction between pizza and time. IMPORTANTLY, all 
# random slopes and intercepts can be correlated.













