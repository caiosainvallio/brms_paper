##############################################################################
#     Advanced Bayesian Multilevel Modeling with the R Package brms          #
#                        Paul-Christian Burkner                              #
##############################################################################
vignette("brms_multilevel")


# families used --------------------------------------------------------------
vignette("brms_families")
vignette("brms_customfamilies")

?brmsfamily



# set prior ------------------------------------------------------------------
?set_prior
help("set_prior")

# https://ben18785.shinyapps.io/distribution-zoo/
  


# multilevel formula syntax --------------------------------------------------
  
# response ~ pterms + (gterms | group)


# `pterms` contain population-level effects (frequentist fixed-effects), 
# assumed to be the same across observations.

# `gterms` contain so called group-level effects (frequentist random-effects),
# assumed to vary across the grouping variables specified in group.

help("brmsformula")
help("addition-terms")





## monotonic measurement error -----------------------------------------------
vignette("brms_monotonic")
# response ~ mo(pterms) + (gterms | group)





# examples -------------------------------------------------------------------
library(brms)
options(mc.cores = parallel::detectCores())
library(tidyverse)

# example 1 - catching fish --------------------------------------------------
# zero-inflated and hurdle models.


# “The state wildlife biologists want to model how many fish are being caught by 
# fishermen at a state park. Visitors are asked how long they stayed, how many 
# people were in the group, were there children in the group and how many fish
# were caught. Some visitors do not fish, but there is no data on whether a 
# person fished or not. Some visitors who did fish did not catch any fish so 
# there are excess zeros in the data because of the people that did not fish.”

zinb <- read.csv("http://stats.idre.ucla.edu/stat/data/fish.csv")
zinb$camper <- factor(zinb$camper, labels = c("no", "yes"))
head(zinb)


system.time(
  fit_zinb1 <- brm(count ~ persons + child + camper, 
                   data = zinb,
                   family = zero_inflated_poisson("log"))
)

summary(fit_zinb1)
# par(mfrow=c(1,3))
conditional_effects(fit_zinb1)

# larger groups catch more fish
# campers catch more fish than non-campers
# groups with more children catch less fish
# The zero-inflation probability zi is pretty large with a mean of 41%
zinb$count %>% hist





# Since we expect groups with more children to avoid fishing, we next try to 
# predict the zero-inflation probability using the number of children.

system.time(
  fit_zinb2 <- brm(bf(count ~ persons + child + camper, zi ~ child),
                   data = zinb, family = zero_inflated_poisson())
)

summary(fit_zinb2)

conditional_effects(fit_zinb2)
zinb$child %>% hist

## as implied by the Poisson part of the model:
# trying to fish with children decreases the overall number fish caught.

## as implied by the zero-inflation part:
# decreases the chance of catching any fish.



### compare models
loo(fit_zinb1, fit_zinb2)



vignette("brms_distreg")



# exemple 2 - housing rents --------------------------------------------------

# The data contains information on roughly 3000 apartments
# 
# absolute rent (rent)
# rent per square meter (rentsqm)
# size of the apartment (area)
# construction year (yearc)
# the district in Munich where the apartment is located (district)

data("rent99", package = "gamlss.data")
head(rent99)

# we wish to predict the rent per square meter using the following explanatory 
# variables: size of the apartment, the construction year, and the district in
# which the apartment is located.

# As the effect of apartment size and construction year predictors is of unknown
# non-linear form, we model these variables using a bivariate tensor spline.

# The district is accounted for using a varying intercept.

system.time(
  fit_rent1 <- brm(rentsqm ~ t2(area, yearc) + (1|district), 
                   data = rent99)
)

summary(fit_rent1)

# For models including splines, the output of summary gives limited information


# First, the credible intervals of the standard deviations of the coefficients 
# forming the splines (under 'Smooth Terms') are sufficiently far away from zero
# to indicate non-linearity in the combined effect of area and yearc.


conditional_effects(fit_rent1, surface = TRUE)




# example 3 - insurance loss payments ----------------------------------------

# predicts the growth of cumulative insurance loss payments over time.

url <- paste0("https://raw.githubusercontent.com/mages/",
              "diesunddas/master/Data/ClarkTriangle.csv")
loss <- read.csv(url)
head(loss)

nlform <- bf(cum ~ ult * (1 - exp(-(dev / theta)^omega)),
             ult ~ 1 + (1|AY), omega ~ 1, theta ~ 1, nl = TRUE)



nlprior <- c(prior(normal(5000, 1000), nlpar = "ult"),
             prior(normal(1, 2), nlpar = "omega"),
             prior(normal(45, 10), nlpar = "theta"))


system.time(
  fit_loss1 <- brm(formula = nlform, data = loss, family = gaussian(),
                   prior = nlprior, control = list(adapt_delta = 0.9))
)

summary(fit_loss1)







brms::fixef()
brms::ranef()


system.time(77*1:1000)



