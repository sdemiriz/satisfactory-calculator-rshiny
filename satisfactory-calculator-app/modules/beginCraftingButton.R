library(shiny)

beginCraftingButtonUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    actionButton(
      inputId = ns('search_crafting_start'), 
      label = 'Begin crafting tree'
    )
  )
}

beginCraftingButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$search_crafting_start)
  })
}

# LEGACY CODE
# actionButton(inputId = 'crafting_start',
#              label = 'Begin crafting tree'),