# Troubleshooting with Lee
# # .libPaths()
# R_LIBS_USER
# R_LIBs

# Looks like RTools isnt installed
# Looks like if admin deletes HTMLtools from programe files I can install fresh
## As I don't have the ability to write over old program files

#assign(".lib.loc", "C:/R_Packages", envir = environment(.libPaths))

pkgbuild::has_rtools()
# looks like the latest rtools wasnt installed. Make sure old versions (4.0  and 4.3 are deleted)
# I need rtools 4.2, i have 4(old) and 4.3 (developer)
# Get Lee to uninstall the other rtools and install the correct one
--------------------------------------------------------------------------------
# Introduction to R, for Economists
library(tidyverse)
## There's a package for everything ----

# XKCD Data 
# Package for downloading XKCD comics
#install.packages("XKCDdata")
library(XKCDdata)
saved_comic <- get_comic(comic = 2048)
print_xkcd(comic = 2048)
print_xkcd(comic = 2327)

 ##

## Flextable--------------------------------------------------------------------

# Lets look at how we might create publication quality tables using the flextable
# package and the mtcars dataset (part of the tidyverse) 

#install.packages("flextable")
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

## gt---------------------------------------------------------------------------

# Do i need this if I have flextable already? Probably not.

#install.packages("gt")
library(gt)

mtcars %>%
  rownames_to_column(var = "model") %>% 
  select(model, mpg) %>% 
  gt()

## ts (Time Series)-------------------------------------------------------------
# install.packages("ts")
# library(ts)
# https://koalatea.io/r-decompose-timeseries/.
# https://www.datascienceinstitute.net/blog/time-series-decomposition-in-r

# OR use



# modeltime--------------------------------------------------------------------- 
# https://cran.r-project.org/web/packages/modeltime/index.html

# Modeltime combines both machine learning and time series modelling in one 
# handy package.

# https://www.rdocumentation.org/packages/modeltime/versions/1.2.4
# this shows the different modelling (ARIMA/ETS/Random Forest/)

# https://cran.r-project.org/web/packages/modeltime/vignettes/getting-started-with-modeltime.html



#install.packages("modeltime")
#install.packages("tidymodels")
#install.packages("lubridate")
library(modeltime)
library(tidymodels)
library(tidyverse)
library(timetk)
library(lubridate)

?bike_sharing_daily
bike_sharing_daily

# Modeltime workflow:
#   1) Split data ito traing and test
#   2) Create and fit models
#   3) Create model table
#   4) Calibrate models
#   5) Perform testing set evaluation
#   6) Refit models to full dataset and forecast


# 1) Selecting the timeseries date variable and the one we want to visualise
bike_data <- bike_sharing_daily %>% 
  select(dteday, cnt)

bike_data %>% plot_time_series(.date_var = dteday, .value = cnt, .interactive = interactive)
interactive <- TRUE

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

# Third lets fit an Error-Trend Season (ETS) model
model_ets <- exp_smoothing() %>% 
  set



##


## Leaflet----------------------------------------------------------------------
install.packages("leaflet")
# https://rstudio.github.io/leaflet/
# https://cran.r-project.org/web/packages/leaflet.minicharts/vignettes/introduction.html

## 

## sf
#install.packages("sf")
library(sf)
