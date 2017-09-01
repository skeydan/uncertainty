library(R.matlab)
library(dplyr)

set.seed(777)

data <- readMat("olympics.mat")
(male400 <- data$male400[ ,1:2])
male400 <- as.data.frame(male400) %>% rename(year = V1, seconds = V2)
male400 <- male400 %>% bind_rows(
  c(year = 2012, seconds = 43.94), c(year = 2016, seconds = 43.03))

# add transformed year as predictor to use in regression
(male400 <- male400 %>% mutate(y = (year - 1896)/4))

# data up till 1996
(male400_1996 <- male400 %>% filter(year < 1997))

# data from 2000
(male400_2000 <- male400 %>% filter(year > 1997))
