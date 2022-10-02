library(shiny)

searchItemFilterUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_item_filter'))
}

searchItemFilterServer <- function(id, RECIPES) {
  moduleServer(id, function(input, output, session) {
      
    output$search_item_filter <- renderUI({
      
      ns <- session$ns
      
      # Find all item names available in provided data
      item_names <- RECIPES %>%
                      select(product) %>%
                      arrange(product) %>%
                      unique() %>%
                      pull()
      
      return(
        selectInput(
          inputId = ns('selected_item'), 
          label = 'Select Item to start Crafting Tree',
          choices = item_names
        )
      )
    })
    
    return(reactive({ input$selected_item }))
  })
}

## LEGACY CODE

# output$item_filter = renderUI({
#   
#   # Find all item names available in provided data
#   unique_item_names = RECIPES %>% 
#                         select(product) %>%
#                         arrange(product) %>%
#                         unique() %>%
#                         pull()
#   
#   # Use found items in dropdown
#   return(
#     selectInput(
#       inputId = 'item_filter', 
#       label = 'Select Item to start Crafting Tree',
#       choices = unique_item_names
#     )
#   )
# })