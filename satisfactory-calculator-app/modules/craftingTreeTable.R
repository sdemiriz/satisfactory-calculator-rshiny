library(shiny)

craftingTreeTableUI <- function(id) {
  
  ns <- NS(id)
  uiOutput(ns('crafting_tree_table'))
}

craftingTreeTableServer <- function(id, CRAFTING_TREE) {
  moduleServer(id, function(input, output, session) {
    
    output$crafting_tree_table <- renderTable({
      
      ns <- session$ns
      CRAFTING_TREE
    })
  })
}