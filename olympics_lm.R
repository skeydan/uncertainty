source("get_data.R")

fit <- lm(seconds ~ y, male400_1996)
summary(fit)

fit %>% predict(newdata = data.frame(year = c(2000, 2004, 2008, 2012, 2016)))
fit %>% predict(newdata = data.frame(year = c(2000, 2004, 2008, 2012, 2016)), interval = "confidence", level = 0.95)
fit %>% predict(newdata = data.frame(year = c(2000, 2004, 2008, 2012, 2016)), interval = "confidence", level = 0.99)
fit %>% predict(newdata = data.frame(year = c(2000, 2004, 2008, 2012, 2016)), interval = "prediction", level = 0.95)
fit %>% predict(newdata = data.frame(year = c(2000, 2004, 2008, 2012, 2016)), interval = "prediction", level = 0.99)


