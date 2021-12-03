##############################################################################
#     brms: An R Package for Bayesian Multilevel Models Using Stan           #
#                        Paul-Christian Burkner                              #
##############################################################################

# package and dataset --------------------------------------------------------
library(brms)
options(mc.cores = parallel::detectCores())

data("kidney", package = "brms")
head(kidney)


# fit model ------------------------------------------------------------------
fit1 <- brm(
  formula = time | cens(censored) ~ age * sex + disease + (1 + age|patient),
  data = kidney, family = lognormal(),
  prior = c(
    set_prior("normal(0,5)", class = "b"),
    set_prior("cauchy(0,2)", class = "sd"),
    set_prior("lkj(2)", class = "cor")
  ),
  warmup = 1000,
  iter = 2000,
  chains = 4,
  control = list(adapt_delta = 0.95)
  # backend = "cmdstanr"
  # opencl(ids = c(0,0))
)


# Group-level terms are of the form (coefs | group), where coefs
# contains one or more variables whose effects are assumed to vary with the levels of the grouping
# factor given in group. Multiple grouping factors each with multiple group-level coefficients
# are possible. In the present example, only one group-level term is specified in which 1 + age
# are the coefficients varying with the grouping factor patient. This implies that the intercept
# of the model as well as the effect of age is supposed to vary between patients. By default,
# group-level coefficients within a grouping factor are assumed to be correlated.







# analyzing the results ------------------------------------------------------

## retorna o codigo em Stan --------------------------------------------------
stancode(fit1)
standata(fit1)


## summary the results -------------------------------------------------------
summary(fit1, waic = TRUE)

## Rhat:
# The Rhat value provides information on the convergence of the algorithm.
# If Rhat is considerably greater than 1 (i.e., > 1.1), the chains have not yet 
# converged and it is necessary to run more iterations and/or set stronger priors.


## plot posterior distributions ----------------------------------------------
plot(fit1)

## more datiled investigation with `shinystan` -------------------------------
shinystan::launch_shinystan(fit1)


## effects os population-level -----------------------------------------------
marginal_effects(fit1) # depreciated
conditional_effects(fit1)





## hypothesis test -----------------------------------------------------------
# Looking at the group-level effects, the standard deviation parameter of age is 
# suspiciously small. To test whether it is smaller than the standard deviation 
# parameter of Intercept, we apply the hypothesis method:

hypothesis(fit1, "Intercept - age > 0", class = "sd", group = "patient")

# The one-sided 95% credible interval does not contain zero, thus indicating that the standard
# deviations differ from each other in the expected direction. In accordance with this finding,
# the Evid.Ratio shows that the hypothesis being tested (i.e., Intercept - age > 0) is about
# 50 times more likely than the alternative hypothesis Intercept - age < 0. 














