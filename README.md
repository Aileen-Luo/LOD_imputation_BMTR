# LOD_BMTR
## Illustration of R code & Stan code for “bmvTobit” function via r package “rstan”

The following R code illustrates the implementation of Bayesian multivariate Tobit regression (BMTR) via r package “rstan” based on the simulated data example on SHFS. The Bayesian multivariate Tobit regression is implemented on exposure with data below LOD. Multiple imputation (MI) would be conducted by randomly sampling from converged Stan iterations after warm-up of complete “imputed” multivariate data with LOD. Predictor dataset would be required to be complete dataset. For predictors that are incomplete themselves, initial imputations would recommend to complete the predictors prior to imputation of the target columns.
The following code was implemented in` R version 4.0.2`. The involved function including: `function “stan” from package “rstan” 2.21.2`; `package “tidyverse” 1.3.0`.

Of note, the result of stan from “rstan” packages may produce warnings. Nevertheless, such information can be often safely ignored, as they do not have much impact on the analysis.

# Usage:
BMTR (yobs, censpt, Zmat, file = 'mvnorm_cens.stan',...)

# Arguments
**yobs** a data frame or a matrix containing the incomplete data. Missing values are coded as NA.

**Zmat** a data frame or a matrix for covariates, including intercept; Numeric design matrix with length(yobs) rows with predictors for yobs. Matrix Zmat may have no missing values. 

**file** specifying the file name of Stan file coding Bayesian mulvariate Tobit regression (BMTR). 

**censpt** LOD values of incomplete data due for data below LOD

# Examples
```
yobs = data_SHFS[,1:3]
Zmat = data_SHFS[,4:ncol(data_SHFS)]
censpt = c(0.52,0.42,2)
BMTR (yobs, censpt, Zmat, file = 'mvnorm_cens.stan')
```
