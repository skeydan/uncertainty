library(R.matlab)
library(dplyr)
library(ggplot2)

data <- readMat("olympics.mat")
data
str(data)
(male100 <- data$male100[ ,1:2])
(female100 <- data$female100[ ,1:2])
(male200 <- data$male200[ ,1:2])
(female200 <- data$female200[ ,1:2])
(male400 <- data$male400[ ,1:2])
(female400 <- data$female400[ ,1:2])

# 2012 men's 400    43.94
# 2016 men's 400    43.03
# 2012 women's 400  49.55
# 2016 women's 400  49.44

### men's 400
male400 <- as.data.frame(male400) %>% rename(year = V1, seconds = V2)
male400 <- male400 %>% bind_rows(
  c(year = 2012, seconds = 43.94), c(year = 2016, seconds = 43.03))
ggplot(male400, aes(x = year, y = seconds)) + geom_line() + ggtitle("Men's 400m Olympic winning times")

male400_1996 <- male400 %>% filter(year < 1997)
ggplot(male400_1996, aes(x = year, y = seconds)) + geom_line() + ggtitle("Men's 400m Olympic winning times")

### women's 400
female400 <- as.data.frame(female400) %>% rename(year = V1, seconds = V2)
female400 <- female400 %>% bind_rows(
  c(year = 2012, seconds = 49.55), c(year = 2016, seconds = 49.44))
ggplot(female400, aes(x = year, y = seconds)) + geom_line() + ggtitle("Women's 400m Olympic winning times")

female400_1996 <- female400 %>% filter(year < 1997)
ggplot(female400_1996, aes(x = year, y = seconds)) + geom_line() + ggtitle("Women's 400m Olympic winning times")

