
# Screen-width utilization configuration
FULL_SCREEN_WIDTH = 12
SIDE_PANEL_WIDTH = 3
MAIN_PANEL_WIDTH = FULL_SCREEN_WIDTH - SIDE_PANEL_WIDTH

# -----------------------------------------------------------------------------
# Front-end definition
ui <- fluidPage(
  
  # Row 1: Title
  fluidRow(
    
    # Full screen width row
    column(FULL_SCREEN_WIDTH, h1("Calculator"))
  ),
  
  # Row 2: Search and Crafting Tree setup sections
  fluidRow(

    # Subtitle for section    
    column(FULL_SCREEN_WIDTH, h3('Search for Recipes')),
    
    # Small part of the screen width
    column(SIDE_PANEL_WIDTH, searchSidebarUI('search_sidebar')
  ),
    
    # Remaining width of screen houses the "Search Results" table
    column(MAIN_PANEL_WIDTH, searchRecipesTableUI('search_recipes_table'))
  ),
  
  # Row 3: Crafting Tree and its sidebar
  fluidRow(
    
    # Subtitle for section
    column(FULL_SCREEN_WIDTH, h3('Complete Crafting Tree')),
    
    # Small part of screen width is take up by the recipe selector
    column(SIDE_PANEL_WIDTH,
           
      # Make recipe selector fields appear grouped
      wellPanel(
      
        # Item selector for Crafting Tree
        craftingInputFilterUI('crafting_input_filter'),
        
        # Recipe selector for Crafting Tree
        craftingRecipeFilterUI('crafting_recipe_filter'),
        
        # Confirm adding the item, recipe to Crafting Tree
        craftingConfirmButtonUI('crafting_confirm_button')
      )
    ),
    
    # Remaining width of the screen houses the "Crafting Tree" table
    column(MAIN_PANEL_WIDTH, tableOutput('crafting_table'))
  )
)