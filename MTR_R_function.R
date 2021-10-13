BMTR <- function (yobs, censpt, predictormat, censind, ...) {
  yobs[is.na(yobs)] <- -99
  
  #standarization
  zscore <- function(v) (v - mean(v)) / sd(v)
  
  cols <- dim(predictormat)[2]
  rows <- dim(predictormat)[1]
  predictormat_std <- predictormat
  for (j in 1:(cols - 1)) predictormat_std[1:rows, j] <- zscore(predictormat[1:rows, j]) 
  
  mvn_censreg_dat <- list(K = ncol(yobs),
                          N = nrow(yobs),
                          y_obs = yobs[, 1:3],
                          is_censored = (censind[, 1:3])*1,
                          censor_point = censpt[1:3],
                          J = ncol(predictormat),
                          Z = predictormat_std)
  
  model <- rstan::stan_model('mvnorm-cens.stan')
  
  vb_fit <- rstan::vb(model, data = mvn_censreg_dat, init = 0.5, seed = 1234, elbo_samples = 200,grad_samples  = 2)
  
  vb_est <- vb_fit@sim$est
  init <- list(beta = vb_est$beta,
               L_omega = vb_est$beta,
               y_1_miss = vb_est$y_1_miss,
               y_2_miss = vb_est$y_2_miss,
               y_3_miss = vb_est$y_3_miss,
               sigma = vb_est$sigma)
  
  init_fun <- function(chain_id) init
  
  fit <- rstan::sampling(model,
                         data = mvn_censreg_dat,
                         chains = 2, iter = 1000,
                         control = list(max_treedepth = 5),
                         init = 0.5, seed = 1234, refresh = 10)
  
  fit_ss <- rstan::extract(fit, permuted = TRUE)
  yimp_MTR_com_data <- c()
  yimp_MTR_com_log <- c()
  yimp <- yobs
  for (k in 1:50) {
    set.seed(1)
    sample_ite <- sample(c((500 + 10*(k-1)):(500 + 10*k)), 1, replace=F)
    
    y1_missing <- fit_ss$y_1_miss[sample_ite,]
    y2_missing <- fit_ss$y_2_miss[sample_ite,]
    y3_missing <- fit_ss$y_3_miss[sample_ite,]
    
    yimp[censind[,1],1] <- y1_missing
    yimp[censind[,2],2] <- y2_missing
    yimp[censind[,3],3] <- y3_missing 
    
    yimp_MTR_com_data[[k]] <- yimp[,1:3]
  }
  
  yimp_MTR_mean <- Reduce("+", yimp_MTR_com_data) / length(yimp_MTR_com_data)
  
  return(yimp_MTR_mean)
  
}
