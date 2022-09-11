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
                numericInput(inputId='item_quantity',
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
        
        selected_quantity = input$item_quantity
        
        crafting_ratio = selected_quantity / selected_recipe$product_rate
        
        selected_recipe$product_rate = crafting_ratio * selected_recipe$product_rate
        
        selected_recipe$input_rate_1 = crafting_ratio * selected_recipe$input_rate_1
        selected_recipe$input_rate_2 = crafting_ratio * selected_recipe$input_rate_2
        selected_recipe$input_rate_3 = crafting_ratio * selected_recipe$input_rate_3
        selected_recipe$input_rate_4 = crafting_ratio * selected_recipe$input_rate_4

        CRAFTING_TREE = CRAFTING_TREE %>% add_row(selected_recipe)
        
        output$crafting_table = renderTable({
          
          crafting_tree_table = CRAFTING_TREE
          
        })
        
        
        gather_inputs = function(source_table, sink_table) {
          
          str_input = 'input_'
          str_input_rate = 'input_rate_'
          
          for (i in c(1,2,3,4)) {
            
            str_input_i = paste0(str_input, i)
            str_input_rate_i = paste0(str_input_rate, i)
            
            to_append = source_table %>% select(all_of(str_input_i), 
                                                all_of(str_input_rate_i)) %>%
                                          rename(total_inputs=all_of(str_input_i), 
                                                 total_inputs_rates=all_of(str_input_rate_i))
            
            sink_table = sink_table %>% add_row(to_append)
            
          }
          
          
            sink_table = sink_table %>% 
                            drop_na() %>%
                            group_by(total_inputs) %>%
                            summarise(total_inputs_rates=sum(total_inputs_rates))
            
            return(sink_table)
          
        }
        
        gather_products = function(source_table, sink_table) {
          
          str_product = 'product'
          str_product_rate = 'product_rate'
          
          to_append = source_table %>% select(all_of(str_product), 
                                              all_of(str_product_rate)) %>%
                                        rename(total_products=all_of(str_product), 
                                               total_products_rates=all_of(str_product_rate))
          
          sink_table = sink_table %>% add_row(to_append)
          
          sink_table = sink_table %>%
                          drop_na() %>%
                          group_by(total_products) %>%
                          summarise(total_products_rates=sum(total_products_rates))
          
          return(sink_table)
          
        }
        
        # print(gather_products(CRAFTING_TREE, TOTAL_INPUTS)$total_inputs_rates)
        # print(gather_products(CRAFTING_TREE, TOTAL_PRODUCTS)$total_products_rates)
      
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
