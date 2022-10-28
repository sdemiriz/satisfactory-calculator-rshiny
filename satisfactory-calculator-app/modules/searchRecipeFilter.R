library(shiny)

searchRecipeFilterUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_recipe_filter'))
}

searchRecipeFilterServer <- function(id, RECIPES, selected_item) {
  moduleServer(id, function(input, output, session) {
      
    # Find all available recipes for the selected item
    selected_recipe <- reactive({
      
      recipe_names <- RECIPES %>%
                        filter(product == selected_item()) %>%
                        select(recipe) %>%
                        arrange(recipe) %>%
                        pull()
      
      recipe_names
    })
    
    # Use found recipes in dropdown
    output$search_recipe_filter <- renderUI({
      
      ns <- session$ns
      selectInput(inputId = ns('selected_recipe'), 
                  label = 'Select Recipe for Selected Item', 
                  choices = selected_recipe())
    })
    
    reactive(input$selected_recipe)
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