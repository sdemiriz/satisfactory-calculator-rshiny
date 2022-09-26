# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # Search Bar Item Selector
  output$item_filter = renderUI({
    
    # Find all item names available in provided data
    unique_item_names = RECIPES %>% 
                          select(product) %>%
                          arrange(product) %>%
                          unique() %>%
                          pull()
    
    # Use found items in dropdown
    return(
      selectInput(
        inputId = 'item_filter', 
        label = 'Select Item to start Crafting Tree',
        choices = unique_item_names
      )
    )
  })
  
  # Search Bar Recipe Selector
  output$recipe_filter = renderUI({
    
    # Find all available recipes for the selected item
    unique_recipe_names = RECIPES %>%
                            filter(
                              product == input$item_filter
                            ) %>%
                            select(recipe) %>%
                            arrange(recipe)
    
    # Prevent returning "recipe" when there is only one recipe for item
    if(count(unique_recipe_names) <= 1) {
      
      unique_recipe_names = unique_recipe_names$recipe[1]
    }
    
    # Use found recipes in dropdown
    return(
      selectInput(
        inputId = 'recipe_filter', 
        label = 'Select Recipe for Selected Item', 
        choices = unique_recipe_names
      )
    )
  })
  
  # Search Bar Table Viewer
  output$recipes_table = renderTable({
    
    # Select crafting-relevant columns from data
    unique_recipe_names = RECIPES %>%
                            select(
                              recipe, 
                              input_1, input_rate_1, 
                              input_2, input_rate_2, 
                              input_3, input_rate_3, 
                              input_4, input_rate_4, 
                              building, 
                              product, product_rate, 
                              byproduct, byproduct_rate
                            ) %>%
                            filter(product == input$item_filter) %>%
                            arrange(recipe)
  })
  
  # Search Bar Start Crafting Button
  observeEvent(input$crafting_start, {
    
    if (length_df(CRAFTING_TREE) == 0) {
      
      # Add user's final selection to Crafting Table if it is empty
      CRAFTING_TREE <<- AddCraftingStepToTree(input$item_filter, 
                                              input$recipe_filter, 
                                              input$item_quantity, 
                                              CRAFTING_TREE)
    } else {
      
      print('Warning: Trying to start crafting for non-empty crafting tree')
    }
    
    # Update the Crafting Table with user's final selection
    output$crafting_table = renderTable({
      
      return(CRAFTING_TREE)
    })
    
    # Gather all inputs from the Crafting Table into list
    ALL_INPUTS_FROM_CRAFTING = GatherInputs(CRAFTING_TREE)
    
    # Add item state and rawness columns
    ALL_INPUTS_FROM_CRAFTING = ALL_INPUTS_FROM_CRAFTING %>%
                                inner_join(
                                  ITEMS, 
                                  by = c('total_inputs' = 'item')
                                ) %>%
                                filter(is_raw == FALSE)
    
    # Get input names from crafting tree
    TOTAL_INPUTS_FROM_CRAFTING = ALL_INPUTS_FROM_CRAFTING$total_inputs
    
    output$input_filter = renderUI({
      
      return(
        selectInput(inputId = 'input_filter',
                    label = 'Select Input to Configure',
                    choices = TOTAL_INPUTS_FROM_CRAFTING)
      )
    })
    
    # Update Crafting Tree Input Selector
    output$recipe_for_input = renderUI({
      
      recipes_from_total_inputs_crafting = RECIPES %>%
                                            filter(
                                              product == input$input_filter
                                            ) %>%
                                            select(recipe) %>%
                                            arrange(recipe) %>%
                                            pull()
      
      return(
        selectInput(inputId = 'recipe_for_input', 
                    label = 'Select Recipe for Selected Input', 
                    choices = recipes_from_total_inputs_crafting)
      )
    })
  })

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
  observeEvent(input$crafting_clear, {
    
    # Clear table using the empty template
    output$crafting_table = renderTable({
      
      CRAFTING_TREE <<- CRAFTING_TEMPLATE
      return(CRAFTING_TREE)
    })
    
    # Clear input filter
    output$input_filter = renderUI({
      
      # Set choices to NULL to clear them
      return(
        selectInput(inputId = 'input_filter',
                    label = 'Select Input Item to Configure',
                    choices = NULL)
      )
    })
    
    # Clear recipe filter
    output$recipe_for_input = renderUI({
      
      # Set choices to NULL to clear them
      return(
        selectInput(inputId = 'recipe_for_input',
                    label = 'Select Recipe for Input Item',
                    choices = NULL)
      )
    })
  })
  
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
