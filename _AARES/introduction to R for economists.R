# Introduction to R, for Economists
library(tidyverse)

# Don't stress about coding along  with me here, 
#   there are a lot of packages to download. Do ask questions and make suggestions

## There's a package for everything---------------------------------------------

# XKCD Data 
# Package for downloading XKCD comics
library(XKCDdata)

print_xkcd(comic = 2048)
print_xkcd(comic = 2327)

## Flextable--------------------------------------------------------------------

# Lets look at how we might create publication quality tables using the flextable
# package and the mtcars dataset (part of the tidyverse) 

library(flextable)

mtcars

# First lets turn the row names into columns called make and model. Note that currently
# they are formatted as rownames rather than as a column which are treated differently

mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  separate(Model, c("make", "model"))

# Now lets only select those columns relating to engine specifications and other 
#  specifications
mtcars %>% 
  select(cyl, hp, disp, mpg, wt, gear)

# Combine both steps and send to flextable
mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable()

# This is ok, but we can add headers and footers to make this better

mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable() %>% 
  add_header_row(values = c("Car","Engine specifications", "Other physical specifications"), 
                 colwidths = c(2,3,3)) %>%   
  add_footer_lines("mtcars data set showing headers and footers in flextable")

# We can even add themes to further improve 
mtcars %>% 
rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable() %>% 
  add_header_row(values = c("Car","Engine specifications", "Other physical specifications"), 
                 colwidths = c(2,3,3)) %>%   
  add_footer_lines("mtcars data set showing headers and footers in flextable") %>% 
  theme_zebra() 

# https://ardata-fr.github.io/flextable-book/design.html
# Show some of the very pretty table sin the documentation


# modeltime--------------------------------------------------------------------- 
# https://cran.r-project.org/web/packages/modeltime/index.html

# Modeltime combines both machine learning and time series modelling in one 
# handy package.

# https://www.rdocumentation.org/packages/modeltime/versions/1.2.4
# this shows the different modelling (ARIMA/ETS/Random Forest/)

# https://cran.r-project.org/web/packages/modeltime/vignettes/getting-started-with-modeltime.html

# Modeltime forecasting---------------------------------------------------------

#install.packages("modeltime")
#install.packages("tidymodels")
#install.packages("lubridate")
library(modeltime)
library(tidymodels)
library(tidyverse)
library(timetk)
library(parsnip)
library(lubridate)

?bike_sharing_daily
bike_sharing_daily

# Modeltime workflow:
#   1) Split data ito training and test
#   2) Create and fit models
#   3) Create model table
#   4) Calibrate models
#   5) Perform testing set evaluation
#   6) Refit models to full dataset and forecast


# 1) Selecting the timeseries date variable and the one we want to visualise
bike_data <- bike_sharing_daily %>% 
  select(dteday, cnt)

interactive <- TRUE

bike_data %>% plot_time_series(.date_var = dteday, .value = cnt, .interactive = interactive)

# this is a plotly (opposed to ggplot visualisation) which means we can interact  
# with it. But we can turn it off with the interactive arg which calls the
# interactive object


splits <- time_series_split(
  data = bike_data, # specifying data 
  date_var = dteday, # specifying the date variable
  assess = "3 months", # specifying the assessment sample
  cumulative = TRUE) # allowing resampling to change the size of the training set

# 2) Create and fit models

## First lets fit an ARIMA 
model_arima <- arima_reg() %>% 
  set_engine(engine = "auto_arima") %>% 
  fit(cnt ~ dteday, data = training(splits))

model_arima

## Second lets fit a Boosted ARIMA
model_boosted_arima <- arima_boost(
  min_n = 2, #min. data points for for node to split
  learn_rate = 0.015 #rate boosting algorithm adapts each iteration
) %>% 
  set_engine(engine = "auto_arima_xgboost") %>% 
  fit(cnt ~ dteday + as.numeric(dteday),
    data = training(splits))

## Third lets fit an Error-Trend Season (ETS) model
model_ets <- exp_smoothing() %>% 
  set_engine(engine = "ets") %>% 
  fit(cnt ~ dteday, data = training(splits))

## Fourth lets fit a Prophet model
model_prophet <- prophet_reg() %>% 
  set_engine(engine = "prophet") %>% 
  fit(cnt ~ dteday, data = training(splits))

## Fifth lets fit a Linear Regression

model_linear_regression <- linear_reg() %>% 
  set_engine(engine = "lm") %>% 
  fit(cnt ~ as.numeric(dteday) + factor(month(dteday, label = T),
                                        ordered = F),
      data = training(splits))
      
# 3) Creating the modeltime table
tbl_models <- modeltime_table(
  model_arima,
  model_boosted_arima,
  model_ets,
  model_prophet,
  model_linear_regression)


tbl_models

# 4) Calibrate to testing sets

tbl_calibration <- tbl_models %>% 
  modeltime_calibrate(new_data = testing(splits))

# 5) Testing set evaluation
tbl_calibration %>% 
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = bike_data) %>% 
  plot_modeltime_forecast(
    .interactive = interactive
  )

modeltime_accuracy(tbl_calibration)

# 6) Refit to full data set and forecast forward
tbl_refit <- tbl_calibration %>% 
  modeltime_refit(data = bike_data)

tbl_refit %>% 
  modeltime_forecast(h = "3 weeks", actual_data = bike_data) %>% 
  plot_modeltime_forecast(
    .legend_max_width = 25
  )

# Now the models are refitted to the actual data. This is just a taste of what
# time series modelling can be like. There are numerous other models we can 
# employ too but for times sake I have shown 5 and the modeltime workflow.

# Decomposition-----------------------------------------------------------------
library(tidyverse) #needed for ggtitle
library(seasonal) #needed for seas()
library(fpp)  #need for the elecequip data set

elecequip %>% seas() %>%
  autoplot() +
  ggtitle("SEATS decomposition of electrical equipment index")

## using sthe previous bikes dataset
ts_bike <- ts(bike_sharing_daily$cnt, frequency = 7)

ts_bike %>%
  stl(s.window="periodic") %>%
  autoplot()



## Leaflet----------------------------------------------------------------------
library(leaflet)
# https://rstudio.github.io/leaflet/
# https://cran.r-project.org/web/packages/leaflet.minicharts/vignettes/introduction.html

# Leadflet creates interactive maps

## Leaflet workflow
#   1) Create a map widget by calling leaflet()
#   2) Add layers/features to map with layer functions
#   3) Repeat step 2 as desired
#   4) Print the map widget to display it

# Map of Auckland University (birthplace of R)
Auckland_University <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
Auckland_University

## Extension - adding several points to an interactive map

NZUs <- tibble(Universities = c("UoA", "AUT", "Waikato", "Massey", "Vic", "Canterbury", "Lincoln", "Otago"),
               lat = c(-36.85224823346041, -36.853412307817784, -37.78890569065363, -40.355225055311955, -41.29002684516775, -43.52237464482431, -43.645401275754104, -45.864063192916205),
               lng = c(174.77252663829262, 174.76643757919567, 175.3164528404978, 175.60943830584307,174.76783598210622, 172.57943539626334, 172.46426811709463, 170.5146851684737)) %>% 
  select(Universities, lng, lat)

NZUs %>% leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = ~lng, lat = ~lat, label = ~Universities, popup = "Universities of New Zealand") 
## Can assign the map and call it if I don't always want it built

## sf --------------------------------------------------------------------------
library(sf)
library(ggthemes)
library(ggrepel)
library(tidyverse)

nz_regions_sf <- st_read("_AARES/linz_download/nz-land-districts.shp")
nz_outline_sf <- st_read("_AARES/linz_outline/nz-coastlines-and-islands-polygons-topo-150k.shp")

# Showing the regions outlines (extend into ocean)
ggplot() +
  geom_sf(data = nz_regions_sf)

# Trimming to the intersection of the coastlines layer
trimmed <- st_intersection(nz_outline_sf, nz_regions_sf)

ggplot()+
  geom_sf(data = trimmed)

# Plotting the trimmed outline and cropping to appropriate coords
ggplot() +
  geom_sf(data = trimmed) +
  coord_sf(xlim = c(165, 180)) 

# Adding NZUs
ggplot() +
  geom_sf(data = trimmed) +
  coord_sf(xlim = c(165, 180)) +
  geom_label_repel(data = NZUs, aes(x = lng, y = lat, label = Universities))

# Can be better again, theme, title, caption, axis labels

# Add the NZUs dataset from before
NZUS_sf <- ggplot() +
  geom_sf(data = trimmed) +
  coord_sf(xlim = c(165, 180)) +
  geom_label_repel(data = NZUs, aes(x = lng, y = lat, label = Universities)) +
  theme_economist() +
  labs (title = "Universities of New Zealand",
       caption = "Coordinates of Universities sourced from GoogleMaps") +
  xlab("Longitude") +
  ylab("Latitude")
