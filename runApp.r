library(shiny)
library(tidyverse)
#runExample('02_text')


import_as_tibble = function(table_dir){
  return(as_tibble(read.csv(table_dir, header = TRUE)))
}

recipes_add_forward_rates = function(recipes_tibble){
  recipes_tibble = recipes_tibble %>% 
    mutate(forward_ratio_1 = input_rate_1/product_rate,
           forward_ratio_2 = input_rate_2/product_rate,
           forward_ratio_3 = input_rate_3/product_rate,
           forward_ratio_4 = input_rate_4/product_rate)
  
  return(recipes_tibble)
}

recipes_add_reverse_rates = function(recipes_tibble){
  recipes_tibble = recipes_tibble %>%
    mutate(reverse_ratio_1 = product_rate/input_rate_1,
           reverse_ratio_2 = product_rate/input_rate_2,
           reverse_ratio_3 = product_rate/input_rate_3,
           reverse_ratio_4 = product_rate/input_rate_4)
  
  return(recipes_tibble)
}

recipes_add_is_byproduct = function(recipes_tibble){
  recipes_tibble = recipes_tibble %>%
    mutate(has_byproduct = !is.na(byproduct_rate))
  
  return(recipes_tibble)
}

# Import recipes table
RECIPES = import_as_tibble('data/recipes.csv')

# Recipes table pre-processing
# Add forward rates
RECIPES = recipes_add_forward_rates(RECIPES)

# Add reverse rates
RECIPES = recipes_add_reverse_rates(RECIPES)

# Add bool column for presence/absence of byproducts of the recipe
RECIPES = recipes_add_is_byproduct(RECIPES)

# Import items table
ITEMS = import_as_tibble('data/items.csv')

# Import buildings table
BUILDINGS = import_as_tibble('data/buildings.csv')

runApp('satisfactory-calculator-app')
