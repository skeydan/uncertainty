library(keras)
library(dplyr)
library(ggplot2)

K <- keras::backend()

source("get_data.R")

n_hidden1 <- 64
n_hidden2 <- 64
n_output <- 1

learning_rate <- 1e-6
num_epochs <- 500
batch_size <- 1

dropout <- 0.1
l2 <- 0.1

#X_train <- matrix(rnorm(n_samples * n_features, mean = 10, sd = 2), nrow = n_samples, ncol = n_features)
X_train <- matrix(male400_1996$year, ncol = 1)
dim(X_train)
y_train <- male400_1996$seconds

model <- keras_model_sequential() 
model %>% 
  layer_dense(units = n_hidden1, activation = 'relu', input_shape = 1) %>% 
  layer_dropout(rate = dropout) %>% 
  layer_activity_regularization(l1=0, l2=l2) %>%
  layer_dense(units = n_hidden2, activation = 'relu') %>%
  layer_dropout(rate = dropout) %>%
  layer_activity_regularization(l1=0, l2=l2) %>%
  layer_dense(units = n_output, activation = 'linear')

model %>% summary()

model %>% compile(
  loss = 'mean_squared_error',
  optimizer = optimizer_adam())
  
history <- model %>% fit(
    X_train, y_train, 
    epochs = num_epochs, batch_size = batch_size 
)

plot(history)
model %>% predict(X_train)

model$layers
get_output = K$`function`(list(model$layers[[1]]$input, K$learning_phase()), list(model$layers[[7]]$output))

# output in train mode = 1
layer_output = get_output(list(matrix(X_train[1:2, ], nrow=2), 1))
layer_output

# output in test mode = 0
layer_output = get_output(list(matrix(X_train[1:2, ], nrow=2), 0))
layer_output

layer_output = get_output(list(X_train, 0))
dim(layer_output[[1]])

# http://mlg.eng.cam.ac.uk/yarin/blog_3d801aa532c1ce.html
n <- 20
inclusion_prob <- 1-dropout
num_samples <- nrow(X_train)
weight_decay <- l2
length_scale <- 0.5

preds <- matrix(NA, nrow = nrow(X_train), ncol = n)
dim(preds)
for(i in seq_len(n)) {
  # train mode
  preds[ ,i] <- get_output(list(X_train, 1))[[1]]
}
preds 

(predictive_mean <- apply(preds, 1, mean))
(predictive_var <-apply(preds, 1, var))
(tau <- length_scale^2 * inclusion_prob / (2 * num_samples * weight_decay))
(predictive_var <- predictive_var + tau^-1)

df <- data.frame(
  x = as.vector(X_train),
  pred_mean = predictive_mean,
  lwr = predictive_mean - sqrt(predictive_var),
  upr = predictive_mean + sqrt(predictive_var)
)

ggplot(df, aes(x = x, y=predictive_mean)) + geom_point() + 
  geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.2) 
