library(keras)
library(dplyr)

K <- keras::backend()

n_samples <- 10000
n_features <- 3
n_hidden1 <- 33
n_hidden2 <- 77
n_output <- 1

learning_rate <- 1e-6
num_epochs <- 5
batch_size <- n_samples / 100

dropout1 <- 0.5
dropout2 <- 0.5

X_train <- matrix(rnorm(n_samples * n_features, mean = 10, sd = 2), nrow = n_samples, ncol = n_features)
dim(X_train)
coefs <- c(0.5, -20, 11)
mu <- X_train %*% coefs
sigma = 2
y_train <- rnorm(n_samples, mu, sigma)

fit <- lm(y_train ~ X_train)
summary(fit)
 
model <- keras_model_sequential() 
model %>% 
  layer_dense(units = n_hidden1, activation = 'relu', input_shape = c(n_features)) %>% 
  layer_dropout(rate = dropout1) %>% 
  layer_dense(units = n_hidden2, activation = 'relu') %>%
  layer_dropout(rate = dropout2) %>%
  layer_dense(units = n_output, activation = 'linear')

model %>% summary()

model %>% compile(
  loss = 'mean_squared_error',
  optimizer = optimizer_adam())
  
history <- model %>% fit(
    X_train, y_train, 
    epochs = num_epochs, batch_size = batch_size, 
    validation_split = 0.2
  )

plot(history)

model$layers
get_output = K$`function`(list(model$layers[[1]]$input, K$learning_phase()), list(model$layers[[5]]$output))

# output in train mode = 1
layer_output = get_output(list(X_train[1:2, ], 1))
layer_output

# output in test mode = 0
layer_output = get_output(list(X_train[1:2, ], 0))
layer_output

layer_output = get_output(list(X_train, 0))
dim(layer_output)

# http://mlg.eng.cam.ac.uk/yarin/blog_3d801aa532c1ce.html
t <- 20
probs <- list()
for(i in 1:t) {
  
}
#   probs += [model.output_probs(input_x)]
# predictive_mean = numpy.mean(prob, axis=0)
# predictive_variance = numpy.var(prob, axis=0)
# tau = l**2 * (1 - model.p) / (2 * N * model.weight_decay)
# predictive_variance += tau**-1
