library(shiny)

beginCraftingButtonUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_crafting_start'))
}

beginCraftingButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$search_crafting_start <- renderUI({
      
      ns <- session$ns
      return(
        actionButton(
          inputId = 'crafting_start', 
          label = 'Begin crafting tree'
        )
      )
    })
    
    return(reactive({ input$crafting_start }))
  })
}

# LEGACY CODE
# actionButton(inputId = 'crafting_start',
#              label = 'Begin crafting tree'),