# Interference and Vaccination in Illinois Project

Authors: Alyssa Anastasi, Ria Cheruki, Chloe Yang, Soren Larsen, Ayesha Mahmud, Pamela Martinez

## Project Question & Approach

**Question**: How does interference between two pathogens influence optimal vaccination timing?  

**Approach**: We aim to approach answering this question from a theoretical perspective. If we have two co-occurring pathogens in a population, we can vary their interference which impacts the timing and total disease burden of each of the pathogens. The true interference between two pathogens is unknown but has been estimated in previous literature. Therefore, staying within the bounds of previously estimated and “realistic” interference, we can observe a range of interference parameters. Within this range of interference parameters, we can observe the effect of vaccination in a population as well as the effect of an ongoing vaccination campaign. 

## Methods

### Two-Pathogen Model Structure

![No Vaccination Figure](figs/seir_grid_no_coinfection_no_vaccination.png)

### Two-Pathogen Model Structure with Vaccination

![Vaccination Figure](figs/seir_grid_no_coinfection_vaccination_route.png)


## Reproducing R environment using renv

This project uses [renv](https://rstudio.github.io/renv/) to manage R packages. The exact package versions are recorded in `renv.lock`, so everyone gets the same environment.

### First-time setup

1. **Get the project.** Clone the repository and open the project folder in R Studio.

2. **Open R inside the project folder.**
   - In RStudio, open the `.Rproj` file. 

   renv activates automatically via `.Rprofile`. On first launch, it may install itself. You should see a message like:
   ```
   - Project '~/.../interference-vaccination' loaded. [renv 1.1.8]
   ```

3. **Install the recorded packages.**
   ```r
   renv::restore()
   ```
   Type `y` when prompted. Packages are installed into a private project library, so your other R projects are not affected.


### Troubleshooting

- **`renv::project()` returns `NULL`:** renv isn't active. Make sure R was started from the project folder