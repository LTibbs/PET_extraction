# Step 2: Extract the PET data for your field site

# load libraries:
# NOTE: this assumes that raster and rgdal packages are already installed. 
# If not, install raster, tidyverse, and data.table using: install.packages(c("raster", "tidyverse", "data.table))
# IMPORTANT: for rgdal, see https://cran.r-project.org/web/packages/rgdal/index.html 
# as you first need to download GDAL and PROJ dependencies from CRAN BEFORE installing rgdal
library(raster)
library(rgdal) # need to download GDAL and PROJ dependencies BEFORE installing this
library(tidyverse)
library(data.table)

setwd("NAM/envs/usgs") # change to your working directory

env_meta_info_0 <- fread("Env_meta_table.txt") # read in environmental metadata
searching_daps <- 150 # how many days after planting do you want to search?

# extract the PET for all latitude/longitude/date combos needed:
output <- vector("list", length=(nrow(env_meta_info_0)*searching_daps))
for (e in 1:nrow(env_meta_info_0)) {
  # pull latitude and longitude
  current.lat <- env_meta_info_0$lat[e]
  current.lon <- env_meta_info_0$lon[e]

  # pull dates
  current.date.list <- seq(as.Date(env_meta_info_0$PlantingDate[e]), length.out = searching_daps, by = "day");
  for (d in seq_along(current.date.list)) {
    pet <- raster(paste0("pet_",year(current.date.list[d]), "/et",
                         format(current.date.list[d], '%y%m%d'), ".bil"))
    current.pet <- raster::extract(pet, data.frame(x=current.lon, y=current.lat))
    output[[(e-1)*searching_daps+d]] <- tibble(env_code=env_meta_info_0$env_code[e],
                                                      date=current.date.list[d],
                                                      PET = current.pet)
  }
}
output.table <- do.call("rbind", output)
fwrite(output.table, "USGS.PETmm.csv", sep=",")
