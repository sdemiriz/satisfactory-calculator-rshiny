
# Front-end definition
ui <- fluidPage(
  
  # Row 1: Title
  fluidRow(
    
    # Full screen width row
    column(full_panel_width, titlePanel("Calculator"))
  ),
  
  # Row 2: Search and Crafting Tree setup sections
  fluidRow(
    
    # Small part of the screen width
    column(side_panel_width,
      
      # Make input fields appear grouped    
      wellPanel(
             
        # Search bar item filter
        uiOutput('item_filter'),
        
        # Search bar recipe filter
        uiOutput('recipe_filter'),
        
        # Search bar quantity selector
        numericInput(inputId='item_quantity',
                      label='Quantity',
                      value=10),
        
        # Button to add selected item, recipe, quantity to crafting section
        actionButton(inputId='crafting_start', 
                      label='Begin crafting tree'),
        
        # Button to clear crafting section, and its input fields
        actionButton(inputId='crafting_clear', 
                      label='Clear crafting tree')
     )
  ),
    
    # Remaining width of screen houses the "Search Results" table
    column(main_panel_width, tableOutput('recipes_table'))
  ),
  
  # Row 3: Crafting Tree and its sidebar
  fluidRow(
    
    # Small part of screen width is take up by the recipe selector
    column(side_panel_width,
           
      # Make recipe selector fields appear grouped
      wellPanel(
      
        # Item selector for Crafting Tree
        uiOutput('dropdown_1'),
        
        # Recipe selector for Crafting Tree
        uiOutput('dropdown_2'),
        
        # Confirm adding the item, recipe to Crafting Tree
        actionButton(inputId='button_1',
                      label='Confirm selections')
      )
    ),
    
    # Remainin with of the screen houses the "Crafting Tree" table
    column(main_panel_width, tableOutput('crafting_table'))
  )
)