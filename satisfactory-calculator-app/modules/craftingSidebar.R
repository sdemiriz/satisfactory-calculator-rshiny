library(shiny)

craftingSidebarUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    wellPanel(
      craftingInputFilterUI(ns('crafting_input_filter')),
      
      craftingRecipeFilterUI(ns('crafting_recipe_filter')),
      
      craftingConfirmButtonUI(ns('crafting_confirm_selection'))
    )
  )
}

craftingSidebarServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    crafting_input <- craftingInputFilterServer('crafting_input_filter', 
                                                c(1,2,3))
    
    crafting_recipe <- craftingRecipeFilterServer('crafting_recipe_filter', 
                                                  c(1,2,3))
    
    crafting_confirm <- craftingConfirmButtonServer('crafting_confirm_selection')
    
    list(crafting_input = reactive(crafting_input()),
         crafting_recipe = reactive(crafting_recipe()),
         crafting_confirm = reactive(crafting_confirm())
    )
  })
}

## LEGACY CODE
# crafting_input <- craftingInputFilterServer('crafting_input_filter', c(1,2,3))
# 
# crafting_recipe <- craftingRecipeFilterServer('crafting_recipe_filter', c(1,2,3))
# 
# crafting_confirm <- craftingConfirmButtonServer('crafting_confirm_button')