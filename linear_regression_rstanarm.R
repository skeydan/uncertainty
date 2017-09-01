library(rstanarm)

source("get_data.R")

fit <- stan_glm(seconds ~ y, male400_1996, family = "gaussian", prior = normal(location = 0), prior_intercept = normal(location = 50))

summary(fit)
plot(fit)

prior_summary(fit)
posterior_vs_prior(fit)

# predictions on new data
newdata <- male400_2000
# A draws by nrow(newdata) matrix of simulations from the posterior predictive distribution. 
# Each row of the matrix is a vector of predictions generated using a single draw
# of the model parameters from the posterior distribution. 
preds <- posterior_predict(fit, newdata = newdata, probs = c(0.05, 0.95))
dim(preds)
predictive_error(preds, y = male400_2000$seconds)
predictive_interval(preds)

# predictions on old data
fitted <- posterior_predict(fit, probs = c(0.05, 0.95))
dim(fitted)
predictive_error(fitted, y = male400_1996$seconds)
predictive_interval(fitted)
