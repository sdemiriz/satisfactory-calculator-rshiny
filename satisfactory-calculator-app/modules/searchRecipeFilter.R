library(shiny)

searchRecipeFilterUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_recipe_filter'))
}

searchRecipeFilterServer <- function(id, RECIPES, selected_item) {
  moduleServer(id, function(input, output, session) {
      
    # Find all available recipes for the selected item
    recipe_names <- reactive({
      
      query_results <- RECIPES %>%
                        filter(product == selected_item()) %>%
                        select(recipe) %>%
                        arrange(recipe)
      
      # Return the single recipe if there is only one
      if(count(query_results) <= 1) {
        
        query_results <- query_results$recipe[1]
      }
      
      return(query_results)
    })
    
    # Use found recipes in dropdown
    output$search_recipe_filter <- renderUI({
      
      ns <- session$ns
      return(
        selectInput(
          inputId = ns('selected_recipe'), 
          label = 'Select Recipe for Selected Item', 
          choices = recipe_names()
        )
      )
    })
    
    return(reactive({ input$selected_recipe }))
  })
}

## LEGACY CODE

# output$recipe_filter = renderUI({
#   
#   # Find all available recipes for the selected item
#   unique_recipe_names = RECIPES %>%
#                           filter(
#                             product == input$item_filter
#                           ) %>%
#                           select(recipe) %>%
#                           arrange(recipe)
#   
#   # Prevent returning "recipe" when there is only one recipe for item
#   if(count(unique_recipe_names) <= 1) {
#     
#     unique_recipe_names = unique_recipe_names$recipe[1]
#   }
#   
#   # Use found recipes in dropdown
#   return(
#     selectInput(
#       inputId = 'recipe_filter', 
#       label = 'Select Recipe for Selected Item', 
#       choices = unique_recipe_names
#     )
#   )
# })