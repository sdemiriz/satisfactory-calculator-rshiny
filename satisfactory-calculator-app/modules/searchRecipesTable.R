library(shiny)

searchRecipesTableUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_recipes_table'))
}

searchRecipesTableServer <- function(id, RECIPES, 
                                     selected_item, selected_quantity) {
  moduleServer(id, function(input, output, session) {
    
    # Search Bar Table Viewer
    output$search_recipes_table <- renderTable({
      
      ns <- session$ns
      
      # Select filtered columns from data
      recipes_table <- RECIPES %>%
                        select(
                          recipe,
                          input_1, input_rate_1,
                          input_2, input_rate_2,
                          input_3, input_rate_3,
                          input_4, input_rate_4,
                          building,
                          product, product_rate,
                          byproduct, byproduct_rate
                        ) %>%
                        filter(product == selected_item()) %>%
                        arrange(recipe)
      
      # Calculate the ratio (how many times the recipe is to be used for the step)
      ratio <- .CalculateRatio(selected_quantity(), recipes_table$product_rate)
      
      # Apply ratio to inputs, product and byproduct
      recipes_table <- ApplyRatio(recipes_table, ratio)
      
      recipes_table
    })
  })
}

## LEGACY CODE
# output$recipes_table = renderTable({
# 
#   # Select crafting-relevant columns from data
#   unique_recipe_names = RECIPES %>%
#                           select(
#                             recipe,
#                             input_1, input_rate_1,
#                             input_2, input_rate_2,
#                             input_3, input_rate_3,
#                             input_4, input_rate_4,
#                             building,
#                             product, product_rate,
#                             byproduct, byproduct_rate
#                           ) %>%
#                           filter(product == selected_item()) %>%
#                           arrange(recipe)
# })