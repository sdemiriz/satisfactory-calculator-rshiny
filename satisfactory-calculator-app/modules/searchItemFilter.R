library(shiny)

searchItemFilterUI <- function(id) {
  
  ns <- NS(id)
  unique_item_names <- RECIPES %>% 
                        select(product) %>%
                        arrange(product) %>%
                        unique() %>%
                        pull()

  tagList(
    selectInput(
      inputId = ns('selected_item'), 
      label = 'Select Item to start Crafting Tree',
      choices = unique_item_names
    )
  )
}

searchItemFilterServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$selected_item)
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