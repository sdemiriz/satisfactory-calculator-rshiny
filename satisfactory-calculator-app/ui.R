
# Screen width utilization config
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
  
  # Row 2: Search section
  fluidRow(

    # Search section heading  
    column(FULL_SCREEN_WIDTH, h3('Search for Recipes')),
    
    # Search section sidebar  
    column(SIDE_PANEL_WIDTH, searchSidebarUI('search_sidebar')),
    
    # Search section Recipes table  
    column(MAIN_PANEL_WIDTH, searchRecipesTableUI('search_recipes_table'))
  ),
  
  # Row 3: Crafting section
  fluidRow(

    # Crafting section heading
    column(FULL_SCREEN_WIDTH, h3('Complete Crafting Tree')),
    
    # Crafting section sidebar
    column(SIDE_PANEL_WIDTH, craftingSidebarUI('crafting_sidebar')),
    # textOutput('debugger'),
    
    # Crafting section Crafting Tree table
    column(MAIN_PANEL_WIDTH, craftingTreeTableUI('crafting_tree_table'))
  )
)