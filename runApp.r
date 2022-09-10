library(shiny)
library(tidyverse)
#runExample('02_text')

options(shiny.port = 8888)

import_as_tibble = function(table_dir){
    
    # Import .csv with header row from specified directory
    return(as_tibble(read.csv(table_dir, header = TRUE)))
}

recipes_add_forward_rates = function(recipes_tibble){
    
    # Add columns for [input_rate_{1,2,3,4} / output_rate]
    recipes_tibble = recipes_tibble %>% 
                        mutate(forward_ratio_1 = input_rate_1/product_rate,
                               forward_ratio_2 = input_rate_2/product_rate,
                               forward_ratio_3 = input_rate_3/product_rate,
                               forward_ratio_4 = input_rate_4/product_rate)
  
    return(recipes_tibble)
}


recipes_add_reverse_rates = function(recipes_tibble){
    
    # Add columns for [output_rate / input_rate_{1,2,3,4}]
    recipes_tibble = recipes_tibble %>%
                        mutate(reverse_ratio_1 = product_rate/input_rate_1,
                               reverse_ratio_2 = product_rate/input_rate_2,
                               reverse_ratio_3 = product_rate/input_rate_3,
                               reverse_ratio_4 = product_rate/input_rate_4)
  
    return(recipes_tibble)
}

recipes_add_has_byproduct = function(recipes_tibble){
    
    # Add bool column to check if recipe has a byproduct
    recipes_tibble = recipes_tibble %>%
                        mutate(has_byproduct = !is.na(byproduct_rate))
  
    return(recipes_tibble)
}

# Import recipes, items, buildings tables
RECIPES = import_as_tibble('data/recipes.csv')
ITEMS = import_as_tibble('data/items.csv')
BUILDINGS = import_as_tibble('data/buildings.csv')

# Recipes table pre-processing
# Add forward, reverse rates
RECIPES = recipes_add_forward_rates(RECIPES)
RECIPES = recipes_add_reverse_rates(RECIPES)

# Add bool column for presence/absence of byproducts of the recipe
RECIPES = recipes_add_has_byproduct(RECIPES)

# Initialize a tibble for the crafting chain
CRAFTING_TEMPLATE = tibble(recipe=character(),
                        input_1=character(), input_rate_1=numeric(),
                        input_2=character(), input_rate_2=numeric(),
                        input_3=character(), input_rate_3=numeric(),
                        input_4=character(), input_rate_4=numeric(),
                        building=character(),
                        product=character(), product_rate=numeric(),
                        byproduct=character(), byproduct_rate=numeric())

CRAFTING_TREE = CRAFTING_TEMPLATE

# Run app located in specified dir at specified port
runApp('satisfactory-calculator-app', port = getOption("shiny.port"))
