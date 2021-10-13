# LOD_BMTR
## Illustration of R code & Stan code for “bmvTobit” function via r package “rstan”

The following R code illustrates the implementation of Bayesian multivariate Tobit regression (BMTR) via r package “rstan” based on the simulated data example on SHFS. The Bayesian multivariate Tobit regression is implemented on exposure with data below LOD. Multiple imputation (MI) would be conducted by randomly sampling from converged Stan iterations after warm-up of complete “imputed” multivariate data with LOD. Predictor dataset would be required to be complete dataset. For predictors that are incomplete themselves, initial imputations would recommend to complete the predictors prior to imputation of the target columns.
The following code was implemented in` R version 4.0.2`. The involved function including: `function “stan” from package “rstan” 2.21.2`; `package “tidyverse” 1.3.0`.

Of note, the result of stan from “rstan” packages may produce warnings. Nevertheless, such information can be often safely ignored, as they do not have much impact on the analysis.

# Usage:
bmvTobit(yobs, censpt, predictormat, censind, iter_m, ...)

# Arguments
**yobs** a data frame or a matrix containing the incomplete data. Missing values are coded as NA.

**predictormat** a data frame or a matrix for covariates, including intercept; Numeric design matrix with length(yobs) rows with predictors for yobs. Matrix Zmat may have no missing values. 

**censind** Indicator values for which are LOD values. 

**censpt** LOD values of incomplete data due for data below LOD

**iter_m** Total number of iterations per chain. The recommended iteration is iter_m = 1000 

# Value
Returns an data frame of multiply imputed data set

# Examples
```
load("nhanes_yobs_200.RData")
load("nhanes_predictormat_200.RData")
nhanes_censpt <- c(0.2,1.91,0.12) 
nhanes_censind <- is.na(nhanes_yobs_200)

bmvTobit(yobs = nhanes_yobs_200, censpt = nhanes_censpt, 
     predictormat = nhanes_predictormat_200, censind = nhanes_censind, iter_m = 1000)
```

# Installation

1.	Go to github link: [https://github.com/Aileen-Luo/LOD_imputation_BMTR] and download stan script ' mvnorm-cens.stan', R script “MTR_R_function.R” and put them in the same working directory.
2.	In R scrip, define yobs as a data frame or a matrix containing the incomplete data. Missing values are coded as -99 in default.
3.	In R scrip, define censpt as LOD values of incomplete data due for data below LOD,
4.	In R scrip, define predictormat as a data frame or a matrix for covariates, including intercept; Standardization for all predictors except incomplete predictor would be conducted automatically in R script. Numeric design matrix with length(yobs) rows with predictors for yobs. Matrix predictormat may have no missing values.
5.	In R script, define iter_m as number of multiple imputation. 
6.	Run script “MTR_R_function.R”, library functions including: function “stan” from package “rstan” 2.21.2; package “tidyverse” 1.3.0.

