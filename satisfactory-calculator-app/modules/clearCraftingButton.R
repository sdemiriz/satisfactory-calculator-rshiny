library(shiny)

clearCraftingButtonUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    actionButton(
      inputId = 'crafting_clear', 
      label = 'Clear crafting tree'
    )
  )
}

clearCraftingButtonServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$search_crafting_clear)
  })
}

# LEGACY CODE
# actionButton(inputId = 'crafting_start',
#              label = 'Begin crafting tree'),