data {
  int<lower=0> N;                 // Number of observations
  int<lower=0> J;                 // Number of weather (groups)
  int<lower=1, upper=J> weather_type[N]; // Category index for each observation
  int<lower=0> volume[N];         // Observed count data
}
parameters {
  real<lower=0> lambda0;             // Overall mean (rate parameter)
  real<lower=0> tau;              // Between-group SD
  real<lower=0> lambda[J];        // Group-specific rate parameters
}
model { // priors
  lambda0 ~ gamma(5, 1);             // Prior for overall mean (Gamma prior)
  tau ~ gamma(2, 1);              // Prior for between-group SD
  // Hierarchical structure for group-specific rates
  lambda ~ gamma(lambda0 * tau, tau); // Gamma prior for lambda[J]
  // Poisson likelihood
  for (n in 1:N) {
    volume[n] ~ poisson(lambda[weather_type[n]]);
  }
}

