# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  
  search_sidebar <- searchSidebarServer('search_sidebar', RECIPES)
  
  searchRecipesTableServer('search_recipes_table',
                           RECIPES, 
                           reactive(search_sidebar$selected_item()),
                           reactive(search_sidebar$selected_quantity()))
  
# -----------------------------------------------------------------------------
  
  crafting_sidebar <- craftingSidebarServer('crafting_sidebar')
  
  craftingTreeTableServer('crafting_tree_table', CRAFTING_TREE)
  
  # output$debugger <- renderText({ paste0(typeof(crafting_sidebar$crafting_input()),
  #                                        ': ',
  #                                        crafting_sidebar$crafting_input())
  # })
  
  # When clearing Crafting Tree
  observeEvent(crafting_sidebar$crafting_confirm(), {
      
    LogCat('Adding selection to Crafting Tree')
    BetterCat('\t Itm:', crafting_sidebar$crafting_input())
    BetterCat('\t Rcp:', crafting_sidebar$crafting_recipe())
    
    # Gather all inputs from the Crafting Table into list
    crafting_tree_inputs <- GatherInputs(CRAFTING_TREE)
    
    # Get production rate required from Crafting Tree
    calculated_quantity <- crafting_tree_inputs %>%
                            filter(
                              total_inputs == crafting_sidebar$crafting_input()
                            ) %>%
                            select(total_input_rates) %>%
                            pull()
    
    # Add input, recipe and quantity as new step to Crafting Tree
    CRAFTING_TREE <<- AddCraftingStepToTree(crafting_sidebar$crafting_input(),
                                            crafting_sidebar$crafting_recipe(),
                                            calculated_quantity,
                                            CRAFTING_TREE)
  })
    
    # net_items = NetProduction(CRAFTING_TREE)
    # 
    # # Update the list in input filter
    # output$input_filter <- renderUI({
    # 
    #   return(
    #     selectInput(inputId = 'input_filter',
    #                 label = 'Select Input to Configure',
    #                 choices = net_items)
    #   )
    # })
}
