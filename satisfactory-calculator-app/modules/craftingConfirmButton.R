library(shiny)

craftingConfirmButtonUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('crafting_confirm_button'))
}

craftingConfirmButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$crafting_confirm_button <- renderUI({
      
      ns <- session$ns
      
      return(
        actionButton(
          inputId = ns('crafting_confirm'),
          label = 'Confirm selections'
        )
      )
    })
    
    return(reactive({ input$crafting_confirm }))
  })
}