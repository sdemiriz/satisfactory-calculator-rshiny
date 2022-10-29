library(shiny)

craftingTreeTableUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('crafting_tree_table'))
}

craftingTreeTableServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Search Bar Table Viewer
    output$crafting_tree_table <- renderTable({
      
      ns <- session$ns
      crafting_tree_table
    })
  })
}