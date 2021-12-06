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

## example 1 - catching fish -------------------------------------------------
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


### compare models
loo(fit_zinb1, fit_zinb2)










brms::fixef()
brms::ranef()


system.time(77*1:1000)



