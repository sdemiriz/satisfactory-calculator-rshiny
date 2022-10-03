# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # Search Bar Item Selector
  selected_item <- searchItemFilterServer('search_item_filter', 
                                          RECIPES)
  
  # Search Bar Recipe Selector
  selected_recipe <- searchRecipeFilterServer('search_recipe_filter', 
                                              RECIPES, selected_item)
  
  # Search Bar Quantity Selector
  selected_quantity <- searchItemQuantityServer('search_item_quantity')
  
  # Search Bar Table Viewer
  searchRecipesTableServer('search_recipes_table', 
                           RECIPES, selected_item)
  
  # Search Bar Start Crafting Tree Button
  crafting_start <- beginCraftingButtonServer('search_crafting_start')
  
  # Search Bar Clear Crafting Tree Button
  crafting_clear <- clearCraftingButtonServer('search_crafting_clear')
  
  crafting_input <- craftingInputFilterServer('crafting_input_filter',
                                              CRAFTING_TREE)
  
  crafting_recipe <- craftingRecipeFilterServer('crafting_recipe_filter',
                                                CRAFTING_TREE)
  
  crafting_confirm <- craftingConfirmButtonServer('crafting_confirm_button')
  
  # Search Bar Start Crafting Button
  # observeEvent(crafting_start, {
  #   
  #   if (length_df(CRAFTING_TREE) == 0) {
  #     
  #     # Add user's final selection to Crafting Table if it is empty
  #     CRAFTING_TREE <<- AddCraftingStepToTree(selected_item, 
  #                                             selected_recipe, 
  #                                             selected_quantity, 
  #                                             CRAFTING_TREE)
  #   } else {
  #     
  #     print('Warning: Trying to start crafting for non-empty crafting tree')
  #   }
  #   
  #   # Update the Crafting Table with user's final selection
  #   output$crafting_table = renderTable({
  #     
  #     return(CRAFTING_TREE)
  #   })
  #   
  #   # Gather all inputs from the Crafting Table into list
  #   ALL_INPUTS_FROM_CRAFTING = GatherInputs(CRAFTING_TREE)
  #   
  #   # Add item state and rawness columns
  #   ALL_INPUTS_FROM_CRAFTING = ALL_INPUTS_FROM_CRAFTING %>%
  #                               inner_join(
  #                                 ITEMS, 
  #                                 by = c('total_inputs' = 'item')
  #                               ) %>%
  #                               filter(is_raw == FALSE)
  #   
  #   # Get input names from crafting tree
  #   TOTAL_INPUTS_FROM_CRAFTING = ALL_INPUTS_FROM_CRAFTING$total_inputs
  #   
  #   output$input_filter = renderUI({
  #     
  #     return(
  #       selectInput(inputId = 'input_filter',
  #                   label = 'Select Input to Configure',
  #                   choices = TOTAL_INPUTS_FROM_CRAFTING)
  #     )
  #   })
  #   
  #   # Update Crafting Tree Input Selector
  #   output$recipe_for_input = renderUI({
  #     
  #     recipes_from_total_inputs_crafting = RECIPES %>%
  #                                           filter(
  #                                             product == input$input_filter
  #                                           ) %>%
  #                                           select(recipe) %>%
  #                                           arrange(recipe) %>%
  #                                           pull()
  #     
  #     return(
  #       selectInput(inputId = 'recipe_for_input', 
  #                   label = 'Select Recipe for Selected Input', 
  #                   choices = recipes_from_total_inputs_crafting)
  #     )
  #   })
  # })

# -----------------------------------------------------------------------------
  # Crafting Tree Input Selector default
  output$input_filter = renderUI({

    return(
      selectInput(inputId = 'input_filter',
                  label = 'Select Input Item to Configure',
                  choices = NULL)
    )
  })

  # Recipe Selector for Selected Input default
  output$recipe_for_input = renderUI({

    return(
      selectInput(inputId = 'recipe_for_input',
                  label = 'Select Recipe for Input Item',
                  choices = NULL)
    )
  })
  
  # When clearing the Crafting Tree
  # observeEvent(input$crafting_clear, {
  #   
  #   # Clear table using the empty template
  #   output$crafting_table = renderTable({
  #     
  #     CRAFTING_TREE <<- CRAFTING_TEMPLATE
  #     return(CRAFTING_TREE)
  #   })
  #   
  #   # Clear input filter
  #   output$input_filter = renderUI({
  #     
  #     # Set choices to NULL to clear them
  #     return(
  #       selectInput(inputId = 'input_filter',
  #                   label = 'Select Input Item to Configure',
  #                   choices = NULL)
  #     )
  #   })
  #   
  #   # Clear recipe filter
  #   output$recipe_for_input = renderUI({
  #     
  #     # Set choices to NULL to clear them
  #     return(
  #       selectInput(inputId = 'recipe_for_input',
  #                   label = 'Select Recipe for Input Item',
  #                   choices = NULL)
  #     )
  #   })
  # })
  
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
