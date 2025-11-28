data {
  int<lower=0> N;            // Number of observations
  int<lower=0> K;            // Number of predictors
  matrix[N, K] X;            // Predictor matrix
  vector[N] y;               // Response vector
}

parameters {
  vector[K] beta;            // Coefficients
  real<lower=0> sigma;       // sd of errors
  real alpha;                // intercept
}

model {
  // Priors
  beta ~ normal(0, 10);      // Prior for coefficients
  // Implicit improper flat prior for intercept
  // Likelihood
  sigma ~ gamma(2, 0.1);
  y ~ normal(X * beta + alpha, sigma);
}

