library(shiny)

searchSidebarUI <- function(id) {
  
  ns <- NS(id)
  
  return(
     # Make input fields appear grouped
     wellPanel(

       # Search bar item filter
       searchItemFilterUI(ns('search_item_filter')),

       # Search bar recipe filter
       searchRecipeFilterUI(ns('search_recipe_filter')),

       # Search bar quantity selector
       searchItemQuantityUI(ns('search_item_quantity')),

       # Button to add selected item, recipe, quantity to crafting section
       beginCraftingButtonUI(ns('search_crafting_start')),

       # Button to clear crafting section, and its input fields
       clearCraftingButtonUI(ns('search_crafting_clear'))
    )
  )
}

searchSidebarServer <- function(id, RECIPES) {
  moduleServer(id, function(input, output, session) {
    
    # Search Bar Item Selector
    selected_item <- searchItemFilterServer('search_item_filter', 
                                            RECIPES)
    
    # Search Bar Recipe Selector
    selected_recipe <- searchRecipeFilterServer('search_recipe_filter', 
                                                RECIPES, selected_item)
    # Search Bar Quantity Selector
    selected_quantity <- searchItemQuantityServer('search_item_quantity')
    
    # Search Bar Start Crafting Tree Button
    crafting_start <- beginCraftingButtonServer('search_crafting_start')
    
    # Search Bar Clear Crafting Tree Button
    crafting_clear <- clearCraftingButtonServer('search_crafting_clear')
    
    # Search Bar Start Crafting Button
    observeEvent(input$crafting_start, {
      
      if (lengthDF(CRAFTING_TREE) == 0) {
        
        # Add user's final selection to Crafting Table if it is empty
        CRAFTING_TREE <<- AddCraftingStepToTree(selected_item(),
                                                selected_recipe(),
                                                selected_quantity(),
                                                CRAFTING_TREE)
      } else {
        
        print('Warning: Trying to start crafting for non-empty crafting tree')
      }
      
      # Update the Crafting Table with user's final selection
      searchRecipesTableServer('crafting_table', CRAFTING_TREE, selected_item())
      
      # Gather all inputs from the Crafting Table into list
      all_inputs_from_crafting <- GatherInputs(CRAFTING_TREE)
      
      # Add item state and rawness columns
      all_inputs_from_crafting <- all_inputs_from_crafting %>%
        inner_join(ITEMS, by=c('total_inputs' = 'item')) %>%
        filter(is_raw == FALSE)
      
      # Get input names from crafting tree
      total_inputs <- all_inputs_from_crafting$total_inputs
      
      selected_input <- craftingInputFilterServer('crafting_input_filter', 
                                                  total_inputs)
      
      # Reactive filtering for input item recipes
      recipes_from_inputs <- reactive({
        RECIPES %>%
          filter(product == selected_input()) %>%
          select(recipe) %>%
          arrange(recipe) %>%
          pull() 
      })
      
      # Update Crafting Tree Input Selector
      observeEvent(recipes_from_inputs(), {
        
        selected_recipe <- craftingRecipeFilterServer('crafting_recipe_filter',
                                                      recipes_from_inputs())
      })
    })
    
    # output$search_sidebar <- renderUI({
    # 
    #   return(
    #     c()
    #   )
    # })
    
    return(reactive({ c(selected_item(), selected_quantity()) }))
  })
}