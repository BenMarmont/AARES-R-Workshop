# Troubleshooting with Lee
# # .libPaths()
# R_LIBS_USER
# R_LIBs

# Looks like RTools isnt installed
# Looks like if admin deletes HTMLtools from programe files I can install fresh
## As I don't have the ability to write over old program files

assign(".lib.loc", "C:/R_Packages", envir = environment(.libPaths))















# Introduction to R, for Economists
library(tidyverse)
## If there is something you want to do, there's probably a package for it ----



 ## Let this be either the first or the last section 

# XKCD Data --------------------------------------------------------------------
# Package for downloading XKCD comics
#install.packages("XKCDdata")
library(XKCDdata)
saved_comic <- get_comic(comic = 2048)
print_xkcd(comic = 2048)
print_xkcd(comic = 2327)

 ##

## Flextable--------------------------------------------------------------------
install.packages("flextable")
library(flextable)
mtcars %>% 
flextable()
# Flextable isn't installing. Requires new htmltools package. New package won't download for me
# Will update RStudio and see if I can from there

## gt---------------------------------------------------------------------------
#install.packages("gt")
library(gt)

mtcars %>%
  gt()

## ts (Time Series)-------------------------------------------------------------
install.packages("ts")
library(ts)
# https://koalatea.io/r-decompose-timeseries/.
# https://www.datascienceinstitute.net/blog/time-series-decomposition-in-r

# OR use modeltime https://cran.r-project.org/web/packages/modeltime/index.html

install.packages("modeltime")

##


## Leaflet----------------------------------------------------------------------
install.packages("leaflet")
# https://rstudio.github.io/leaflet/
# https://cran.r-project.org/web/packages/leaflet.minicharts/vignettes/introduction.html

## 

## sf
#install.packages("sf")
library(sf)
