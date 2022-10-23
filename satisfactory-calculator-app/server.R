# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  
  search_sidebar <- searchSidebarServer('search_sidebar', RECIPES)
  
  # When clearing the Crafting Tree
  observeEvent(input$crafting_clear, {
    
    print('Clearing Crafting Tree')

    CRAFTING_TREE <<- CRAFTING_TEMPLATE
    
  })
  
  crafting_input <- craftingInputFilterServer('crafting_input_filter', NULL)
  
  crafting_recipe <- craftingRecipeFilterServer('crafting_recipe_filter', NULL)
  
  crafting_confirm <- craftingConfirmButtonServer('crafting_confirm_button')
  
# -----------------------------------------------------------------------------
  # Crafting Table default
  output$crafting_table = renderTable({

    return(CRAFTING_TREE)
  })

  observeEvent(input$button_1, {
    
    # Gather all inputs from the Crafting Table into list
    all_inputs_from_crafting = GatherInputs(CRAFTING_TREE)
    
    # Get production rate required from Crafting Tree
    calculated_quantity = all_inputs_from_crafting %>%
                            filter(total_inputs == input$input_filter) %>%
                            select(total_input_rates) %>%
                            pull()
      
    # Add input, recipe and quantity as new step to Crafting Tree
    CRAFTING_TREE <<- AddCraftingStepToTree(input$input_filter,
                                            input$recipe_for_input,
                                            calculated_quantity,
                                            CRAFTING_TREE)
      
    # Update Crafting Table on screen
    output$crafting_table = renderTable({
      
      return(CRAFTING_TREE)
    })
    
    net_items = NetProduction(CRAFTING_TREE)
    
    # Update the list in input filter
    output$input_filter = renderUI({
      
      return(
        selectInput(inputId = 'input_filter',
                    label = 'Select Input to Configure',
                    choices = net_items)
      )
    })
  })
}
