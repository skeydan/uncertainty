library(rethinking)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(ggjoy)

### how link works ###
# R code 4.58, http://xcelab.net/rmpubs/rethinking/code.txt
post <- extract.samples(model)
mu.link <- function(weight) post$a + post$b*weight
xs <- seq( from=25 , to=70 , by=1)
mu <- sapply(xs, mu.link)

### how sim works ###
# R code 4.63
post <- extract.samples(model)
xs <- 25:70
sims <- sapply( xs , function(x)
  rnorm(
    n=nrow(post) ,
    mean=post$a + post$b*weight ,
    sd=post$sigma) )

###############################################

source("get_data.R")

model <- map2stan(
  alist(
    seconds ~ dnorm(mu, sigma),
    mu <- a + b*year,
    a ~ dnorm(46, 30),
    b ~ dnorm(0,10),
    sigma ~ dcauchy(0, 10)
  ),
  data = male400_1996,
  iter = 6000,
  chains = 4,
  verbose = TRUE
)

precis(model)

post <- extract.samples(model)
str(post)
post[1:5, ]


### plot regression lines for samples from posterior
plot( male400_1996$year , male400_1996$seconds ,
      xlim=range(male400_1996$year) , ylim=range(male400_1996$seconds) ,
      col=rangi2 , xlab="" , ylab="" )
for ( i in 1:20 )
  abline( a=post$a[i] , b=post$b[i] , col=col.alpha("black",0.3))


### posterior samples for for the regression line
mu <- link( model)
str(mu)
dim(mu)

ys <- seq(from=1896 , to=2016 , by=4)

mu <- link(model, data=data.frame(year=ys) )
str(mu)
dim(mu)

plot( seconds ~ year , male400_1996 , type="n" )
for ( i in 1:100 )
  points( ys , mu[i,] , pch=16 , col=col.alpha(rangi2,0.1) )

### posterior interval for the regression line
mu.mean <- apply(mu , 2 , mean)
mu.HPDI <- apply(mu , 2 , HPDI , prob=0.89)

plot( seconds ~ year , male400_1996 , col=col.alpha(rangi2,0.5) )
lines(ys , mu.mean)
shade(mu.HPDI , ys)


### prediction intervals
sims <- sim( model , data=list(year=ys) )
str(sims)

sim.PI <- apply( sims , 2 , PI , prob=0.89 )

plot( seconds ~ year , male400_1996 , col=col.alpha(rangi2,0.5))
lines( ys , mu.mean )
shade( mu.HPDI , ys )
shade( sim.PI , ys )


### joyplot
#df <- data.frame(mu)
df <- data.frame(sims)
df <- df %>% 
  gather(key = "year", value = "secs") %>% 
  mutate(year = as.numeric(str_sub(year,2,3)))

convert_years <- function(x) 1896 + 4* (x-1)

ggplot(df, aes(x = secs, y = year, group = year, height = ..density..)) + geom_joy(stat = "density", rel_min_height = 0.01, scale=4) +
  scale_x_reverse() + scale_y_reverse() + theme_joy(grid = FALSE) +
  scale_y_continuous(labels = convert_years) 

ggplot(df, aes(x = secs, y = year, group = year)) + geom_joy(rel_min_height = 0.01, scale=4) +
  scale_x_reverse() + scale_y_reverse() + theme_joy(grid = FALSE) +
  scale_y_continuous(labels = convert_years) 




