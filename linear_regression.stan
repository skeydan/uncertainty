data {                      // Data block
  int<lower=1> n;           // Sample size
  int<lower=1> k;           // Dimension of model matrix
  matrix[n, k] X;           // Model Matrix
  vector[n] y;              // Target variable
}

parameters {                // Parameters block
  vector[k] beta;           // Coefficient vector
  real<lower=0> sigma;      // Error scale
}

model {                     // Model block
  vector[n] mu;
  mu = X * beta;           // Creation of linear predictor
  
  // priors
  beta[1] ~ cauchy(0,10);
  beta[2] ~ cauchy(0, 2.5);
  sigma ~ cauchy(0, 5);     
  
  // likelihood
  y ~ normal(mu, sigma);
  
}

generated quantities {
  real rss;                
  real totalss;
  real R2;                 
  vector[n] mu;
  vector[n] y_pred;
  
  mu = X * beta;
  rss = dot_self(y - mu);
  totalss = dot_self(y - mean(y));
  R2 = 1 - rss/totalss;
  
  for(i in 1:n){
    y_pred[i] = normal_rng(X[i,] * beta, sigma);
  }

}
