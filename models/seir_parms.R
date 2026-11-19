# SEIR Parameters 

### General Parameters ###

times <- 1:512
pop <- 12549689 # Census Data for Illinois

## No Vaccination ##
### Initial Parameters 

no_vacc_names_var <- c("SS", 
                       "ES", "IS", "RS", "RE", "RI", 
                       "SE", "SI", "SR", "ER", "IR",
                       "RR")

no_vacc_init <- rep(0,length(no_vacc_names_var))
names(no_vacc_init) <- no_vacc_names_var
no_vacc_init["SS"] <- pop - 2
no_vacc_init["IS"] <- 1
no_vacc_init["SI"] <- 1


## Parameters are sourced from Literature 


# Pathogen A ~ COVID, Pathogen B ~ Flu
cov_flu_parms <- c(beta_A=0.63, epsilon_A = 1/3, gamma_A = 1/5, 
                   beta_B=0.36, epsilon_B = 1/3, gamma_B = 1/7, 
                   beta_AB=0.5, beta_BA=0.5)

# Pathogen A ~ COVID, Pathogen B ~ RSV
cov_rsv_parms <- c(beta_A=0.63, epsilon_A = 1/3, gamma_A = 1/5, 
                   beta_B=0.31, epsilon_B = 1/5, gamma_B = 1/8, 
                   beta_AB=0.5, beta_BA=0.5)

# Pathogen A ~ Flu, Pathogen B ~ RSV
flu_rsv_parms <- c(beta_A=0.36, epsilon_A = 1/3, gamma_A = 1/7, 
                   beta_B=0.31, epsilon_B = 1/5, gamma_B = 1/8, 
                   beta_AB=0.5, beta_BA=0.5)


## with Vaccination ##
### Initial Conditions

vacc_names_var <- c(no_vacc_names_var,
                    "VS", "VE", "VI", "VR",
                    "SV", "EV", "IV", "RV",
                    "VV")

vacc_init <- rep(0, length(vacc_names_var))
names(vacc_init) <- vacc_names_var
vacc_init[no_vacc_names_var] <- no_vacc_init

add_vacc_parms <- function(parms, vA, vB, vAB,
                           beta_VA = parms[["beta_A"]],
                           beta_VB = parms[["beta_B"]]) {
  c(parms,
    vA = vA, vB = vB, vAB = vAB,
    beta_VA = beta_VA, beta_VB = beta_VB)
}

cov_flu_vacc_parms <- add_vacc_parms(cov_flu_parms, vA = 0.005, vB = 0.005, vAB = 0.002)
cov_rsv_vacc_parms <- add_vacc_parms(cov_rsv_parms, vA = 0.005, vB = 0.005, vAB = 0.002)
flu_rsv_vacc_parms <- add_vacc_parms(flu_rsv_parms, vA = 0.005, vB = 0.005, vAB = 0.002)



### Seasonality Cubic Splines ### 

#' Seasonal forcing curve from a 6-parameter cyclic cubic spline
#' Returns cubic spline matrix for 6 seasonality parameters
#' 
#' @param mu_janfeb mu value for january - february
#' @param mu_marapr mu value for march - april
#' @param mu_mayjun mu value for may - june
#' @param mu_julaug mu value for july - august
#' @param mu_septoct mu value for september - october
#' @param mu_novdec mu value for november to december 
#' @return Dataframe with 365 rows and 2 columns: 
#' \describe{
#'   \item{day}{Day of year, indexed 0-364 (day 365 is recoded as 0).}
#'   \item{Value}{The seasonal curve value for that day: the mean of the six
#'   parameter-weighted spline basis functions.}
#' }
seas_matrix <- function(mu_janfeb, mu_marapr, mu_mayjun, mu_julaug, mu_septoct, mu_novdec){
  n <- 365
  x <- 0:(n-1)/(n-1);
  k<- 0:6/6
  matrix <- cSplineDes(x, k, ord = 4, derivs=0) %>%
    as.data.frame() %>%
    mutate(day = 1:365) %>%
    rename(JanFeb = V1, MarApr = V2, MayJun = V3, JulAug = V4, SeptOct = V5, NovDec = V6) %>%
    pivot_longer(JanFeb:NovDec, values_to = "Value", names_to = "Season") %>%
    mutate(spline_scalar = case_when(
      Season == "JanFeb" ~ mu_janfeb,
      Season == "MarApr" ~ mu_marapr,
      Season == "MayJun" ~ mu_mayjun,
      Season == "JulAug" ~ mu_julaug,
      Season == "SeptOct" ~ mu_septoct,
      Season == "NovDec" ~ mu_novdec
    )) %>%
    mutate(Value = spline_scalar*Value) %>%
    group_by(day) %>% 
    summarise(Value = mean(Value)) %>%
    ungroup() %>%
    mutate(day = if_else(day == 365, 0, day))
  return(matrix)
}


#' Get current seasonality parameter 
#' 
#' @param t timestep
#' @param matrix seasonality matrix, as given from seasonality_matrix() function
#' @return mu value at time t
seas_function <- function(t, matrix){
  matrix <- matrix %>%
    filter(day == floor(t) %% 365)
  mu <- matrix$Value[1]
  return(mu)
}