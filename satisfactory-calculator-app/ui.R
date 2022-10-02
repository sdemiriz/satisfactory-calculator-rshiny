
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
    column(SIDE_PANEL_WIDTH,
      
      # Make input fields appear grouped    
      wellPanel(
             
        # Search bar item filter
        searchItemFilterUI('search_item_filter'),
        
        # Search bar recipe filter
        searchRecipeFilterUI('search_recipe_filter'),
        
        # Search bar quantity selector
        searchItemQuantityUI('search_item_quantity'),
        
        # Button to add selected item, recipe, quantity to crafting section
        beginCraftingButtonUI('search_crafting_start'),
        
        # Button to clear crafting section, and its input fields
        clearCraftingButtonUI('search_crafting_clear')
     )
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
        uiOutput('input_filter'),
        
        # Recipe selector for Crafting Tree
        uiOutput('recipe_for_input'),
        
        # Confirm adding the item, recipe to Crafting Tree
        actionButton(inputId = 'button_1',
                      label = 'Confirm selections')
      )
    ),
    
    # Remaining width of the screen houses the "Crafting Tree" table
    column(MAIN_PANEL_WIDTH, tableOutput('crafting_table'))
  )
)