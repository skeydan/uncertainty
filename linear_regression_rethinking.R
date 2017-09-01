library(rethinking)

source("get_data.R")


model <- map2stan(
  alist(
    seconds ~ dnorm(mu, sigma),
    mu <- a + b*y,
    a ~ dnorm(50, 100),
    b ~ dnorm(0,10),
    sigma ~ dcauchy(0, 2)
  ),
  data = male400_1996,
  iter = 6000,
  chains = 4,
  verbose = TRUE
)

precis(model)

post <- extract.samples(model)
post[1:5, ]

post <- extract.samples(model, n=20 )

# display raw data and sample size
plot( dN$weight , dN$height ,
      xlim=range(d2$weight) , ylim=range(d2$height) ,
      col=rangi2 , xlab="weight" , ylab="height" )
mtext(concat("N = ",N))

# plot the lines, with transparency
for ( i in 1:20 )
  abline( a=post$a[i] , b=post$b[i] , col=col.alpha("black",0.3) 