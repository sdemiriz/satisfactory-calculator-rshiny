library(shiny)
library(tidyverse)
#runExample('02_text')

options(shiny.port = 8888)

FULL_PANEL_WIDTH = 12
side_panel_width = 3
main_panel_width = FULL_PANEL_WIDTH - side_panel_width

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

gather_inputs = function(source_table) {
  
  TOTAL_INPUTS = tibble(total_inputs=character(),
                        total_inputs_rates=numeric())
  
  sink_table = TOTAL_INPUTS
  
  str_input = 'input_'
  str_input_rate = 'input_rate_'
  
  for (i in c(1,2,3,4)) {
    
    str_input_i = paste0(str_input, i)
    str_input_rate_i = paste0(str_input_rate, i)
    
    to_append = source_table %>% 
      select(all_of(str_input_i), 
             all_of(str_input_rate_i)) %>%
      rename(total_inputs=all_of(str_input_i), 
             total_inputs_rates=all_of(str_input_rate_i))
    
    sink_table = sink_table %>% add_row(to_append)
    
  }
  
  
  sink_table = sink_table %>% 
    drop_na() %>%
    group_by(total_inputs) %>%
    summarise(total_inputs_rates=sum(total_inputs_rates))
  
  return(sink_table)
  
}

gather_products = function(source_table) {
  
  TOTAL_PRODUCTS = tibble(total_products=character(),
                          total_products_rates=numeric())
  
  sink_table = TOTAL_PRODUCTS
  
  str_product = 'product'
  str_product_rate = 'product_rate'
  
  to_append = source_table %>% 
    select(all_of(str_product), 
           all_of(str_product_rate)) %>%
    rename(total_products=all_of(str_product), 
           total_products_rates=all_of(str_product_rate))
  
  sink_table = sink_table %>% add_row(to_append)
  
  sink_table = sink_table %>%
    drop_na() %>%
    group_by(total_products) %>%
    summarise(total_products_rates=sum(total_products_rates))
  
  return(sink_table)
  
}

gather_byproducts = function(source_table) {
  
  TOTAL_BYPRODUCTS = tibble(total_byproducts=character(),
                            total_byproducts_rates=numeric())
  
  sink_table = TOTAL_BYPRODUCTS
  
  str_byproduct = 'byproduct'
  str_byproduct_rate = 'byproduct_rate'
  
  to_append = source_table %>% select(all_of(str_byproduct), 
                                      all_of(str_byproduct_rate)) %>%
    rename(total_byproducts=all_of(str_byproduct), 
           total_byproducts_rates=all_of(str_byproduct_rate))
  
  sink_table = sink_table %>% add_row(to_append)
  
  sink_table = sink_table %>%
    drop_na() %>%
    group_by(total_byproducts) %>%
    summarise(total_byproducts_rates=sum(total_byproducts_rates))
  
  return(sink_table)
  
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
