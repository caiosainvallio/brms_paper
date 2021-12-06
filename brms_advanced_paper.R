##############################################################################
#     Advanced Bayesian Multilevel Modeling with the R Package brms          #
#                        Paul-Christian Burkner                              #
##############################################################################


# families used --------------------------------------------------------------
vignette("brms_families")
vignette("brms_customfamilies")

?brmsfamily


# set prior ------------------------------------------------------------------
?set_prior
help("set_prior")

# https://ben18785.shinyapps.io/distribution-zoo/
  

# multilevel formula syntax ----------------------------------------------------
  

# response ~ pterms + (gterms | group)


# `pterms` contain population-level effects, assumed to be the same 
# across observations.

# `gterms` contain so called group-level effects, assumed to vary across 
# the grouping variables specified in group


