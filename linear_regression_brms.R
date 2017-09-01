library(brms)

source("get_data.R")

# tbd specify prior!!
fit <- brm(seconds ~ y, male400_1996)
summary(fit)
plot(fit)

# predictions on new data
newdata <- male400_2000
# predictions of the responses
predict(fit, newdata = newdata, probs = c(0.05, 0.95))
# predictions of the regression line
fitted(fit, newdata = newdata, probs = c(0.05, 0.95))

# predictions on old data
predict(fit, probs = c(0.05, 0.95))
fitted(fit, probs = c(0.05, 0.95))

# alias of predict.brmsfit with summary = FALSE
# posterior_predict(fit) 
