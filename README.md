# PET_extraction
Extract daily local Potential Evapotranspiration (PET) data from USGS tar.gz files. This is designed to extract daily PET values for agricultural field trial locations on each day during the growing season.

# You will need:
Environmental metadata file (see example: "Env_meta_table.txt") with five columns:
- "env_code": name of environment or field
- "lat": latitude
- "lon": longitude
- "PlantingDate": the planting date in that field
- "TrialYear": year

The tar.gz file with the PET values for the year of interest. Download from https://earlywarning.usgs.gov/fews/product/81 by clicking "Download" > "Daily data (Year)" > "Download Data". In my case, I downloaded 2006 data to the working directory "NAM/envs/usgs/".

# Step 1: Decompress the tar.gz
Run the following code in the RStudio terminal or other command line to decompress the file:
```
cd NAM/envs/usgs/ # use your working directory here
for f in *.tar.gz; do tar -xvf "$f"; done
cd pet_2006
for f in *.tar.gz; do tar -xvf "$f"; done
```

# Step 2: Extract PET data for your field
Run the `PET_extraction.R` code.
