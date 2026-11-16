### Population-level 2-pathogen SEIR Model

#' Two-pathogen SEIR model without vaccination for use in ODE function in deSolve package 
#' We have 2 pathogens: Pathogen A and Pathogen B
#' In compartments, the first letter refers to Pathogen A and the second letter refers to Pathogen B
#' Returns list of gradients for each compartment at current timestep t
#' 
#' @param t current timestep
#' @param y vector of current compartment counts 
#' @param pars parameters of seir model (sourced from seir_source.R) 
#' @return list of gradients for each compartment 
seir_no_vacc <- function(t, y, pars) {
  
  # Bring all params into current function environment 
  list2env(as.list(y), envir=environment())
  list2env(as.list(pars), envir=environment())
  
  # Infectious individuals
  sumI_A <- IS + IR   ## Pathogen A 
  sumI_B <- SI + RI   ## Pathogen B
  pop <- sum(y)
  
  
  # if beta is a function, then use as function
  # if not, use beta term
  beta_A <- if (is.function(beta_A)) beta_A(t) else beta_A
  beta_B <- if (is.function(beta_B)) beta_B(t) else beta_B
  beta_AB <- if (is.function(beta_AB)) beta_AB(t) else beta_AB # Infected with A and then B
  beta_BA <- if (is.function(beta_BA)) beta_BA(t) else beta_BA # Infected with B and then A
  
  # Force of infection (single homogeneous population, so no contact matrix because it gets absorbed via beta anyways)
  lambda_A <- beta_A * sumI_A / pop
  lambda_B <- beta_B * sumI_B / pop
  lambda_AB <- beta_AB * sumI_B / pop
  lambda_BA <- beta_BA * sumI_A / pop
  
  
  # Gradient calculations
  
  # Susceptible to both
  dSS <- -(lambda_A * SS) - (lambda_B * SS)
  
  ## Pathogen A -> Pathogen B
  dES <- (lambda_A * SS) - (epsilon_A * ES)
  dIS <- (epsilon_A * ES) - (gamma_A * IS)
  dRS <- (gamma_A * IS) - (lambda_AB * RS)
  dRE <- (lambda_AB * RS) - (epsilon_B * RE)
  dRI <-  (epsilon_B * RE) - (gamma_B * RI)
  
  ## Pathogen B -> Pathogen A
  dSE <- (lambda_B * SS) - (epsilon_B * SE)
  dSI <- (epsilon_B * SE) - (gamma_B * SI)
  dSR <- (gamma_B * SI) - (lambda_BA * SR)
  dER <- (lambda_BA * SR) - (epsilon_A * ER)
  dIR <-  (epsilon_A * ER) - (gamma_A * IR)
  
  ### Recovered from both
  dRR <- (gamma_A * IR) + (gamma_B * RI)
  
  list(c(
    dSS, 
    
    dES, dIS, dRS, dRE, dRI, 
    dSE, dSI, dSR, dER, dIR,
    
    dRR))
  
}
