data {
  int<lower=0> N;  // number of observations
  int<lower=0> y[N];  // data vector y
}
parameters {
  real<lower = 0> lambda; // mean parameter
}
model { // model
  for (n in 1:N) {
    y[n] ~ poisson(lambda);
  }
  lambda ~ gamma(2, 1); // prior
}
