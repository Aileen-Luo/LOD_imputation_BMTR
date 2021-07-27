data {
  int<lower = 0> N;  // 2126
  int<lower = 0> K;  // 2
  int<lower = 0> J;  // 7
  vector[K] y_obs[N];
  int<lower = 0, upper = 1> is_censored[N, K];
  vector[K] censor_point;
  vector[J] Z[N];
}
parameters {
  vector<upper = censor_point[1]>[sum(is_censored[, 1])] y_1_miss;  // 646
  vector<upper = censor_point[2]>[sum(is_censored[, 2])] y_2_miss;  // 516
  vector<upper = censor_point[3]>[sum(is_censored[, 3])] y_3_miss;  // 594
  matrix[K, J] beta;
  cholesky_factor_corr[K] L_Omega;
  vector<lower = 0>[K] sigma;
}

model {
  vector[K] mu[N];
  vector[K] y[N];
  int pos[K] = rep_array(0, 3);

  for (n in 1:N)
    mu[n] = beta * Z[n];

  for (n in 1:N) {
    if (is_censored[n, 1]) {
      pos[1] += 1;
      y[n, 1] = y_1_miss[pos[1]];
    } else {
      y[n, 1] = y_obs[n, 1];
    }
    if (is_censored[n, 2]) {
      pos[2] += 1;
      y[n, 2] = y_2_miss[pos[2]];
    } else {
      y[n, 2] = y_obs[n, 2];
    }
    if (is_censored[n, 3]) {
       pos[3] += 1;
       y[n, 3] = y_3_miss[pos[3]];
    } else {
       y[n, 3] = y_obs[n, 3];
    }
  }

  L_Omega ~ lkj_corr_cholesky(10);
  to_vector(beta) ~ normal(0, 2);
  sigma ~ normal(0, 2);
  y ~ multi_normal_cholesky(mu, diag_pre_multiply(sigma, L_Omega));
}

generated quantities {
  matrix[K, K] Omega = L_Omega * L_Omega';  // multiply_lower_tri_self_transpose(L_Omega);
}
