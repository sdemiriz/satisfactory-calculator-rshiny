library(shiny)
library(tidyverse)

# This part uses the recipes table for brevity, if full list of items is used
# many of them will not have a recipe
unique_product_names = RECIPES %>% 
                          select(product) %>%
                          arrange(decreasing=TRUE) %>%
                          unique()

FULL_PANEL_WIDTH = 12
side_panel_width = 3
main_panel_width = FULL_PANEL_WIDTH - side_panel_width

ui <- fluidPage(
  
    # App title
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
                selectInput(inputId='item_filter', 
                            label='Select Item', 
                            choices=unique_product_names),
                
                # Placeholder for when this UI is generated based on selected item
                uiOutput('recipe_filter'),
                
                # Amount of selected item to produce using the selected recipe
                numericInput(inputId='quantity',
                             label='Quantity',
                             value=0),
                
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
            
                selectInput(inputId='dropdown-1',
                            label='Select input to craft',
                            choices=c(1,2,3)),
                
                selectInput(inputId='dropdown-2',
                            label='Select recipe to use',
                            choices=c(1,2,3)),
                
                actionButton(inputId='button-1',
                             label='Confirm selections')
              
            )
               
        ),
        
        column(main_panel_width,
               
               
               # Maybe have a bar with buttons for all the functions?
               tableOutput('crafting_table')
               
        ),
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
    output$recipe_filter = renderUI({
    
        unique_recipe_names = RECIPES %>%
                                filter(product == input$item_filter) %>%
                                select(recipe) %>%
                                arrange(decreasing=TRUE)
        
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
                                  arrange(recipe, decreasing=TRUE)
    
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
        
        CRAFTING_TREE = CRAFTING_TREE %>% add_row(selected_recipe)
        
        output$crafting_table = renderTable({
          
          crafting_tree_table = CRAFTING_TREE
          
        })
      
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
