library(shiny)

clearCraftingButtonUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('search_crafting_clear'))
}

clearCraftingButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$search_crafting_clear <- renderUI({
      
      ns <- session$ns
      return(
        actionButton(
          inputId = 'crafting_clear', 
          label = 'Clear crafting tree'
        )
      )
    })
    
    return(reactive({ input$crafting_clear }))
  })
}

# LEGACY CODE
# actionButton(inputId = 'crafting_start',
#              label = 'Begin crafting tree'),