library(shiny)
library(tidyverse)

# This part uses the recipes table for brevity, if full list of items is used
# many of them will not have a recipe
unique_product_names = RECIPES %>% 
                          select(product) %>%
                          arrange(decreasing=TRUE) %>%
                          unique()

# Temporary
unique_recipe_names = RECIPES %>%
                          #filter(product == product) %>%
                          select(recipe) %>%
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
      selectInput(inputId='recipe_filter', 
                  label='Select Recipe', 
                  choices=unique_recipe_names),
      
      # Quantity input (unimplemented)
      numericInput(inputId='quantity',
                   label='Quantity',
                   value=0)
      ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      textOutput('item_selection')
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  output$item_selection = renderText({
                            paste0('The selected item is: ', input$item_filter)
  })
  
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
}

shinyApp(ui=ui, server=server)
