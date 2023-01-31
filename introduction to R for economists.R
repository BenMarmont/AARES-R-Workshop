# Introduction to R, for Economists
library(tidyverse)
## If there is something you want to do, there's probably a package for it ----



 ## Let this be either the first or the last section 

# Package for downloading XKCD comics 
#install.packages("XKCDdata")
library(XKCDdata)
saved_comic <- get_comic(comic = 2048)
print_xkcd(comic = 2048)
print_xkcd(comic = 2327)

 ##

## Flextable 
install.packages("flextable")
library(flextable)
mtcars %>% 
flextable()
