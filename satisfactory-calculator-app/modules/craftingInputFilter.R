library(shiny)

craftingInputFilterUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('crafting_input_filter'))
}

craftingInputFilterServer <- function(id, choices) {
  moduleServer(id, function(input, output, session) {
    
    output$crafting_input_filter <- renderUI({
      
      ns <- session$ns
      return(
        selectInput(
          inputId = ns('crafting_input_filter'),
          label = 'Select Input to Configure',
          choices = choices
        )
      )
    })
    
    return(reactive({ input$crafting_input_filter }))
  })
}