BMTR <- function (yobs, censpt, Zmat, file = 'mvnorm_censreg_test_4.stan',...) {
  filedir <- getwd() 
  censind <- sweep(yobs, 2, censpt)
  yobs[is.na(yobs)] <- -99
  mvn_censreg_dat <- list(K = ncol(yobs),
                          N = nrow(yobs),
                          y_obs = yobs[, 1:3],
                          is_censored = (!censind[, 1:3])*1,
                          censor_point = log(censpt[1:3]),
                          J = ncol(Zmat),
                          Z = Zmat
  )
  
  mvn_censreg_fit <- stan(file = paste(filedir, 'mvnorm_censreg.stan', sep = '/'),
                          data = mvn_censreg_dat, iter = 50)
  mvn_censreg_fit <- stan(fit = mvn_censreg_fit, data = mvn_censreg_dat, iter = 1000)
  
  fit_ss <- rstan::extract(mvn_censreg_fit, permuted = TRUE)
  yimp_MTR_com_data <- c()
  yimp_MTR_com_log <- c()
  yimp <- yobs
  for (k in 1:50) {
    set.seed(1)
    sample_ite <- sample(c((1000 + 20*(k-1)):(1000 + 20*k)), 1, replace=F)
    
    y1_missing <- fit_ss$y_1_miss[sample_ite,]
    y2_missing <- fit_ss$y_2_miss[sample_ite,]
    y3_missing <- fit_ss$y_3_miss[sample_ite,]
    
    yimp[!censind[,1],1] <- y1_missing
    yimp[!censind[,2],2] <- y2_missing
    yimp[!censind[,3],3] <- y3_missing 
    
    yimp_MTR_com_data[[k]] <- yimp[,1:3]
  }
  
  yimp_MTR_mean <- Reduce("+", yimp_MTR_com_data) / length(yimp_MTR_com_data)
  
  dfy_MTR <- yimp_MTR_mean
  
  return(dfy_MTR)
}

