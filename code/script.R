# 1. Load packages ----

library(tidyverse)
library(sf)
sf_use_s2(FALSE)

# 2. Load data ----

data_unesco <- st_read("data/02_world-heritage/World_Heritage_Sites.shp") %>% 
  st_as_sf(crs = 4326)

data_reefs <- st_read("data/01_reefs-area_wri/reef_500_poly.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES"))

# 3. Dataviz ----

# 3.1 Global map --

ggplot() +
  geom_sf(data = data_unesco) +
  geom_sf(data = data_reefs, color = "red")

# 3.2 Map on GBR --

ggplot() +
  geom_sf(data = data_unesco) +
  geom_sf(data = data_reefs, color = "red") +
  coord_sf(ylim = c(-27, -10), xlim = c(140, 160))

# 4. Spatial intersection ----

data_filtered <- st_intersection(data_unesco, data_reefs)

# 4. Dataviz ----

# 4.1 Global map --

ggplot() +
  geom_sf(data = data_unesco) +
  geom_sf(data = data_filtered, color = "red")

# 4.2 Map on GBR --

ggplot() +
  geom_sf(data = data_unesco) +
  geom_sf(data = data_filtered, color = "red") +
  coord_sf(ylim = c(-27, -10), xlim = c(140, 160))

# 5. Calculate the percentage of coral reefs within World Heritage areas ----

area_unesco <- data_filtered %>% st_area() %>% sum() # Total area of coral reefs within world heritage

area_all <- data_reefs %>% st_area() %>% sum() # Total area of coral reefs

area_unesco*100/area_all # Percentage of coral reefs within world heritage

area_all*1e-6 # Total area of coral reefs in km²

area_unesco*1e-6 # Total area of coral reefs within world heritage in km²
