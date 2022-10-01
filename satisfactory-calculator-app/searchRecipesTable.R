library(shiny)

searchRecipesTableUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_recipes_table'))
}

searchRecipesTableServer <- function(id, RECIPES, selected_item) {
  moduleServer(id, function(input, output, session) {
    
    # Search Bar Table Viewer
    output$search_recipes_table <- renderTable({
      
      ns <- session$ns
      
      # Select crafting-relevant columns from data
      unique_recipe_names <- RECIPES %>%
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
      
      return(unique_recipe_names)
    })
  })
}

## LEGACY CODE