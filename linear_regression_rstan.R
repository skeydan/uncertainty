library(R.matlab)
library(rstan)
library(dplyr)
library(shinystan)

set.seed(777)

data <- readMat("olympics.mat")
(male400 <- data$male400[ ,1:2])
male400 <- as.data.frame(male400) %>% rename(year = V1, seconds = V2)
male400 <- male400 %>% bind_rows(
  c(year = 2012, seconds = 43.94), c(year = 2016, seconds = 43.03))
male400_1996 <- male400 %>% filter(year < 1997)

male400_1996 <- male400_1996 %>% mutate(year = (year - 1896)/4)

X = cbind(intercept=1, male400_1996$year)

y <- male400_1996$seconds

dat <- list(n = nrow(X), k=ncol(X), y=y, X=X)

fit <- stan(file='linear_regression_bayes.stan', data=dat, iter = 2000, verbose = TRUE)
print(fit, pars = c("beta", "sigma", "R2"))

plot(fit, pars = c("beta", "sigma"), show_density = TRUE, ci_level = 0.5, fill_color = "purple")

plot(fit, plotfun = "hist", pars = c("beta", "sigma"))
plot(fit, plotfun = "trace", pars = c("beta", "sigma"))

stan_trace(fit)
shinystan::launch_shinystan(fit)

# extract the simulated draws from the posterior and note the number for nsims
theta = extract(fit)
preds <- theta$y_pred
dim(preds)

