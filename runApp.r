library(shiny)
library(tidyverse)

options(shiny.port = 8888)
options(shiny.autoreload = TRUE)

# Run app located in specified dir at specified port
runApp('satisfactory-calculator-app', port = getOption("shiny.port"))
