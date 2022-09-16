library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  fluidRow(
    
    column(FULL_PANEL_WIDTH,
           
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
        
        actionButton(inputId='button-1',
                    label='Confirm selections')
        
        )
    ),
    
    column(main_panel_width,
           
      # Maybe have a bar with buttons for all the functions?
      tableOutput('crafting_table')
           
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  output$item_filter = renderUI({
    
    unique_item_names = RECIPES %>% 
      select(product) %>%
      arrange(product) %>%
      unique()
    
    selectInput(inputId='item_filter', 
                label='Select Item',
                choices=unique_item_names)
  })
  
  output$recipe_filter = renderUI({
    
    unique_recipe_names = RECIPES %>%
      filter(product == input$item_filter) %>%
      select(recipe) %>%
      arrange(recipe)
    
    # If only one recipe to make the item, don't show dropdown
    if (count(unique_recipe_names) <= 1){
      unique_recipe_names = unique_recipe_names$recipe[[1]]
    }
    
    # Define the selectInput
    selectInput(inputId='recipe_filter', 
                label='Select Recipe', 
                choices=unique_recipe_names)
  })
  
  output$recipes_table = renderTable({
    
    unique_recipe_names = RECIPES %>%
      select(recipe, 
             input_1, input_rate_1, 
             input_2, input_rate_2, 
             input_3, input_rate_3, 
             input_4, input_rate_4, 
             building, 
             product, product_rate, 
             byproduct, byproduct_rate) %>%
      filter(product == input$item_filter) %>%
      arrange(recipe)
    
  })
  
  observeEvent(input$crafting_start, {
    
    selected_recipe = RECIPES %>%
      filter(product == input$item_filter,
             recipe == input$recipe_filter) %>%
      select(recipe, 
             input_1, input_rate_1,
             input_2, input_rate_2,
             input_3, input_rate_3,
             input_4, input_rate_4,
             building,
             product, product_rate,
             byproduct, byproduct_rate)
    
    selected_quantity = input$item_quantity
    
    crafting_ratio = selected_quantity / selected_recipe$product_rate
    
    selected_recipe$product_rate = crafting_ratio * selected_recipe$product_rate
    selected_recipe$byproduct_rate = crafting_ratio * selected_recipe$byproduct_rate
    
    selected_recipe$input_rate_1 = crafting_ratio * selected_recipe$input_rate_1
    selected_recipe$input_rate_2 = crafting_ratio * selected_recipe$input_rate_2
    selected_recipe$input_rate_3 = crafting_ratio * selected_recipe$input_rate_3
    selected_recipe$input_rate_4 = crafting_ratio * selected_recipe$input_rate_4
    
    CRAFTING_TREE = CRAFTING_TREE %>% add_row(selected_recipe)
    
    output$crafting_table = renderTable({
      
      CRAFTING_TREE
      
    })
    
    all_inputs_from_crafting = gather_inputs(CRAFTING_TREE)
    
    all_inputs_from_crafting = all_inputs_from_crafting %>% 
      inner_join(ITEMS, by=c("total_inputs"="item")) %>%
      filter(is_raw==FALSE)
    
    total_inputs_from_crafting = all_inputs_from_crafting$total_inputs
    
    output$dropdown_1 = renderUI({
      
      selectInput(inputId='dropdown_1',
                  label='Select Recipe',
                  choices=total_inputs_from_crafting)
    })
    
    output$dropdown_2 = renderUI({
      
      recipes_from_total_inputs_crafting = RECIPES %>%
                                            filter(product==input$dropdown_1) %>%
                                            select(recipe) %>%
                                            arrange(recipe)
      
      print(count(recipes_from_total_inputs_crafting))
      
      # Define the selectInput
      selectInput(inputId='dropdown_2', 
                  label='Select Recipe', 
                  choices=recipes_from_total_inputs_crafting)
    })
    
  })
  
  output$dropdown_1 = renderUI({
    
    # Define the selectInput
    selectInput(inputId='dropdown_1',
                label='Select Input',
                choices=character(0))
  })
  
  output$dropdown_2 = renderUI({
    
    # Define the selectInput
    selectInput(inputId='dropdown_2',
                label='Select Recipe',
                choices=character(0))
  })
  
  observeEvent(input$crafting_clear, {
    
    output$crafting_table = renderTable({
      
      crafting_tree_table = CRAFTING_TEMPLATE
      
    })
    
  })
  
  output$crafting_table = renderTable({
    
    crafting_tree_table = CRAFTING_TEMPLATE
    
  })
}

shinyApp(ui=ui, server=server)
