library(shiny)

searchItemQuantityUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_item_quantity'))
}

searchItemQuantityServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$search_item_quantity <- renderUI({
      
      ns <- session$ns
      return(
        numericInput(
          inputId = ns('selected_quantity'),
          label = 'Select Quantity of Item',
          value = 10,
          min = 1
        )
      )
    })
    
    return(reactive({ input$selected_quantity }))
  })
}

# LEGACY CODE
# Search bar quantity selector
# numericInput(inputId = 'item_quantity',
#              label = 'Select Quantity of Item',
#              value = 10),