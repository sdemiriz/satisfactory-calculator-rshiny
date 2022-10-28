library(shiny)

searchItemQuantityUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    numericInput(inputId = ns('selected_quantity'),
                  label = 'Select Quantity of Item',
                  value = 1,
                  min = 1
    )
  )
}

searchItemQuantityServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$selected_quantity)
  })
}

# LEGACY CODE
# Search bar quantity selector
# numericInput(inputId = 'item_quantity',
#              label = 'Select Quantity of Item',
#              value = 10),