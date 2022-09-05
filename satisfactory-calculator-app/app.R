library(shiny)
library(tidyverse)

# This part uses the recipes table for brevity, if full list of items is used
# many of them will not have a recipe
unique_product_names = RECIPES %>% 
                          select(product) %>%
                          arrange(decreasing=TRUE) %>%
                          unique()

ui <- fluidPage(
  
  # App title ----
  titlePanel("Calculator"),
  
  # Responsive sidebar
  # items filter dropdown (selectInput) - DONE
  # recipes filter dropdown, values reactive to items filter (selectInput)
  # quantity input field (numericInput)
  
  # Responsive main panel
  # table responsive to dropdowns in sidebar (renderDataTable)
  
  sidebarLayout(
    sidebarPanel(
      # Item filter
      selectInput(inputId='item_filter', 
                  label='Select Item', 
                  choices=unique_product_names),
      
      # Recipe filter based on item filter (unimplemented)
      # selectInput(inputId='recipe_filter', 
      #             label='Select Recipe', 
      #             choices=character(0)),
      
      uiOutput('recipe_filter'),
      
      # Quantity input (unimplemented)
      numericInput(inputId='quantity',
                   label='Quantity',
                   value=0)
      ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      dataTableOutput('recipes_table')
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  output$recipe_filter = renderUI({
    
    unique_recipe_names = RECIPES %>%
                            filter(product == input$item_filter) %>%
                            select(recipe) %>%
                            arrange(decreasing=TRUE)
    
    selectInput('recipe_filter', 
                'Select Recipe', 
                unique_recipe_names)
  })
  
  output$recipes_table = renderDataTable({
    
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
  
}

shinyApp(ui=ui, server=server)
