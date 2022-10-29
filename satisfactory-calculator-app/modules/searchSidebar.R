library(shiny)

searchSidebarUI <- function(id) {
  
  ns <- NS(id)
  tagList(
    wellPanel(
      searchItemFilterUI(ns('search_item_filter')),
      
      searchRecipeFilterUI(ns('search_recipe_filter')),
      
      searchItemQuantityUI(ns('search_item_quantity')),
      
      beginCraftingButtonUI(ns('search_crafting_start')),
      
      clearCraftingButtonUI(ns('search_crafting_clear'))
    )
  )
}

searchSidebarServer <- function(id, RECIPES) {
  moduleServer(id, function(input, output, session) {
    
    selected_item <- searchItemFilterServer('search_item_filter')
    
    selected_recipe <- searchRecipeFilterServer('search_recipe_filter', 
                                                RECIPES, 
                                                reactive(selected_item()))
    
    selected_quantity <- searchItemQuantityServer('search_item_quantity')
    
    crafting_start <- beginCraftingButtonServer('search_crafting_start')
    
    crafting_clear <- clearCraftingButtonServer('search_crafting_clear')
    
    list(selected_item = reactive(selected_item()),
         selected_recipe = reactive(selected_recipe()),
         selected_quantity = reactive(selected_quantity()),
         start = reactive(crafting_start()),
         clear = reactive(crafting_clear())
    )
    
    # # Search Bar Start Crafting Button
    # observeEvent(input$crafting_start, {
    #   
    #   if (lengthDF(CRAFTING_TREE) == 0) {
    #     
    #     # Add user's final selection to Crafting Table if it is empty
    #     CRAFTING_TREE <<- AddCraftingStepToTree(selected_item(),
    #                                             selected_recipe(),
    #                                             selected_quantity(),
    #                                             CRAFTING_TREE)
    #   } else {
    #     
    #     print('Warning: Trying to start crafting for non-empty crafting tree')
    #   }
    #   
    #   # Update the Crafting Table with user's final selection
    #   searchRecipesTableServer('crafting_table', CRAFTING_TREE, selected_item())
    #   
    #   # Gather all inputs from the Crafting Table into list
    #   all_inputs_from_crafting <- GatherInputs(CRAFTING_TREE)
    #   
    #   # Add item state and rawness columns
    #   all_inputs_from_crafting <- all_inputs_from_crafting %>%
    #     inner_join(ITEMS, by=c('total_inputs' = 'item')) %>%
    #     filter(is_raw == FALSE)
    #   
    #   # Get input names from crafting tree
    #   total_inputs <- all_inputs_from_crafting$total_inputs
    #   
    #   selected_input <- craftingInputFilterServer('crafting_input_filter', 
    #                                               total_inputs)
    #   
    #   # Reactive filtering for input item recipes
    #   recipes_from_inputs <- reactive({
    #     RECIPES %>%
    #       filter(product == selected_input()) %>%
    #       select(recipe) %>%
    #       arrange(recipe) %>%
    #       pull() 
    #   })
    #   
    #   # Update Crafting Tree Input Selector
    #   observeEvent(recipes_from_inputs(), {
    #     
    #     selected_recipe <- craftingRecipeFilterServer('crafting_recipe_filter',
    #                                                   recipes_from_inputs())
    #   })
    # })
  })
}