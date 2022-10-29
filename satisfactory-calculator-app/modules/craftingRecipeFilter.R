library(shiny)

craftingRecipeFilterUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('crafting_recipe_filter'))
}

craftingRecipeFilterServer <- function(id, choices) {
  moduleServer(id, function(input, output, session) {
    
    output$crafting_recipe_filter <- renderUI({
      
      ns <- session$ns
      selectInput(
        inputId = ns('crafting_recipe_filter'),
        label = 'Select recipe for input',
        choices = choices
      )
    })
    
    reactive(input$crafting_recipe_filter)
  })
}