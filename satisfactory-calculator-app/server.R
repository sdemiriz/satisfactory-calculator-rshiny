
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
    
    CRAFTING_TREE = add_crafting_step_to_tree(input$item_filter, input$recipe_filter, 
                                              input$item_quantity, CRAFTING_TREE)
    
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
  })
  
  output$crafting_table = renderTable({
    
    crafting_tree_table = CRAFTING_TEMPLATE
  })
}