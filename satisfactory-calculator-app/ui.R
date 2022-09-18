
ui <- fluidPage(
  
  fluidRow(
    
    column(full_panel_width,
           
      titlePanel("Calculator")
    )
  ),
  
  # Item, recipe, quantity selector panel
  fluidRow(
    
    column(side_panel_width,
           
      wellPanel(
             
        # Item filter
        uiOutput('item_filter'),
        
        # Recipe filter
        uiOutput('recipe_filter'),
        
        # Amount of selected item to produce using the selected recipe
        numericInput(inputId='item_quantity',
                      label='Quantity',
                      value=10),
        
        actionButton(inputId='crafting_start', 
                      label='Begin crafting tree'),
        
        actionButton(inputId='crafting_clear', 
                      label='Clear crafting tree')
     )
  ),
    
    column(main_panel_width,
           
      tableOutput('recipes_table')
    )
  ),
  
  # Crafting table
  fluidRow(
    
    column(side_panel_width,
           
      wellPanel(
      
      uiOutput('dropdown_1'),
      
      uiOutput('dropdown_2'),
      
      actionButton(inputId='button_1',
                    label='Confirm selections')
      )
    ),
    
    column(main_panel_width,
           
      # Maybe have a bar with buttons for all the functions?
      tableOutput('crafting_table')
    )
  )
)