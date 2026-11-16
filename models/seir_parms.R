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