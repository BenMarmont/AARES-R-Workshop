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

## gt---------------------------------------------------------------------------
#install.packages("gt")
library(gt)

mtcars %>%
  rownames_to_column(var = "model") %>% 
  select(model, mpg) %>% 
  gt()

## ts (Time Series)-------------------------------------------------------------
install.packages("ts")
library(ts)
# https://koalatea.io/r-decompose-timeseries/.
# https://www.datascienceinstitute.net/blog/time-series-decomposition-in-r

# OR use modeltime https://cran.r-project.org/web/packages/modeltime/index.html

#install.packages("modeltime")
library(modeltime)




##


## Leaflet----------------------------------------------------------------------
install.packages("leaflet")
# https://rstudio.github.io/leaflet/
# https://cran.r-project.org/web/packages/leaflet.minicharts/vignettes/introduction.html

## 

## sf
#install.packages("sf")
library(sf)
