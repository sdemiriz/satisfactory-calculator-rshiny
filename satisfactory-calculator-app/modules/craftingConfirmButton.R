library(shiny)

craftingConfirmButtonUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    actionButton(
      inputId = ns('crafting_confirm_selection'),
      label = 'Confirm recipe'
    )
  )
}

craftingConfirmButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$crafting_confirm_selection)
  })
}