# -----------------------------------------------------------------------------
# Screen-width utilization configuration
FULL_SCREEN_WIDTH = 12
SIDE_PANEL_WIDTH = 3
MAIN_PANEL_WIDTH = FULL_SCREEN_WIDTH - SIDE_PANEL_WIDTH

# -----------------------------------------------------------------------------
# Import a .csv file as tibbles from a specified directory
ImportAsTibble = function(path_to_table, table_name) {
  
  # Assemble full path for table
  full_path = paste0(path_to_table, table_name)
  
  # Read the file
  csv_file = read.csv(full_path, header = TRUE)
  
  # Return as tibble
  return(as_tibble(csv_file))
}

# Define root folder
root_dir = '../data/'

# Import recipes, items, buildings tables
RECIPES = ImportAsTibble(root_dir, 'recipes.csv')
ITEMS = ImportAsTibble(root_dir, 'items.csv')
BUILDINGS = ImportAsTibble(root_dir, 'buildings.csv')

# -----------------------------------------------------------------------------
# Add and populate columns for each of the 4 forward ratios
AddForwardRatios = function(recipes_tibble) {
  
  # Add and populate columns for each of the 4 forward ratios
  recipes_tibble = recipes_tibble %>% 
                    mutate(
                      forward_ratio_1 = input_rate_1/product_rate,
                      forward_ratio_2 = input_rate_2/product_rate,
                      forward_ratio_3 = input_rate_3/product_rate,
                      forward_ratio_4 = input_rate_4/product_rate
                    )
  
  return(recipes_tibble)
}

# Add and populate columns for each of the 4 reverse ratios
AddReverseRatios = function(recipes_tibble) {
  
  recipes_tibble = recipes_tibble %>%
                    mutate(
                      reverse_ratio_1 = product_rate/input_rate_1,
                      reverse_ratio_2 = product_rate/input_rate_2,
                      reverse_ratio_3 = product_rate/input_rate_3,
                      reverse_ratio_4 = product_rate/input_rate_4
                    )
  
  return(recipes_tibble)
}

# Add column to signify if recipe has a byproduct
AddHasByproduct = function(recipes_tibble) {
  
  recipes_tibble = recipes_tibble %>%
                    mutate(
                      has_byproduct = !is.na(byproduct_rate)
                    )
  
  return(recipes_tibble)
}

# -----------------------------------------------------------------------------
# Call generic function to return the content of input columns
GatherInputs = function(CRAFTING_TREE) {
  
  return(.GatherColumns(CRAFTING_TREE, 'input'))
}

# Call generic function to return the content of the product column
GatherProducts = function(CRAFTING_TREE) {

  return(.GatherColumns(CRAFTING_TREE, 'product'))
}

# Call generic function to return the content of the byproduct column
GatherByproducts = function(CRAFTING_TREE) {
  
  return(.GatherColumns(CRAFTING_TREE, 'byproduct'))
}

# Generic function to return contents of column(s) as one
.GatherColumns = function(CRAFTING_TREE, col_type) {
  
  # Use specified column type for future columns names
  str_col = paste0('total_', col_type, 's')
  str_col_rate = paste0('total_', col_type, '_rates')
  
  # Generate table to return at the end with appropriate columns
  total_table = tibble({{ str_col }}:=character(), 
                       {{ str_col_rate }}:=numeric())
  
  # If single columns are requested
  if(col_type == 'product' | col_type == 'byproduct') {
    
    # Mimic column names in the crafting tree tables
    str_col_tree = paste0(col_type)
    str_col_rate_tree = paste0(col_type, '_rate')
    
    # Select the mimicked columns and rename them to local names generated at the start
    to_append = CRAFTING_TREE %>% 
                  select(
                    {{ str_col_tree }}, 
                    {{ str_col_rate_tree }}
                  ) %>%
                  rename(
                    {{ str_col }}:={{ str_col_tree }}, 
                    {{ str_col_rate }}:={{ str_col_rate_tree }}
                  )
    
    # Add to the final table to be returned, remove NAs if present
    total_table = total_table %>% 
                  add_row(to_append) %>% 
                  drop_na()
    
    # Group by item name and sum all rates for each item
    total_table = .GetPerItemRates(total_table, str_col, str_col_rate)
    
    # If 4 input columns are requested
  } else if(col_type == 'input') {
    
    # For each of the 4 input columns
    for(i in 1:4) {
      
      # Mimic column names in the crafting tree tables
      str_col_i = paste0(col_type, '_', i)
      str_col_rate_i = paste0(col_type, '_rate_', i)
      
      # Select the mimicked columns and rename them to local names generated at the start
      to_append = CRAFTING_TREE %>%
                    select(
                      {{ str_col_i }}, 
                      {{ str_col_rate_i }}
                    ) %>%
                    rename(
                      {{ str_col }}:={{ str_col_i }}, 
                      {{ str_col_rate }}:={{ str_col_rate_i }}
                    )
      
      # Add to the final table to be returned, remove NAs if present
      total_table = total_table %>% 
                      add_row(to_append) %>% 
                      drop_na()
      
      # Group by item name and sum all rates for each item
      total_table = .GetPerItemRates(total_table, str_col, str_col_rate)
    }
  }
  
  return(total_table)
}

# Worker function to group tables by item name and sum rates
.GetPerItemRates = function(table, grp_by, grp) {
  
  table = table %>%
    group_by(.data[[grp_by]]) %>%
    summarise({{ grp }}:=sum(.data[[grp]]))
  
  return(table)
}

# -----------------------------------------------------------------------------
# Add calculated crafting step to the crafting tree table
AddCraftingStepToTree = function(item_filter, 
                                 recipe_filter, 
                                 quantity, 
                                 CRAFTING_TREE) {
  
  # Query all available recipes for user selection via parameters
  recipe_row = RECIPES %>%
                filter(
                  product == item_filter,
                  recipe == recipe_filter
                ) %>%
                select(
                  recipe, 
                  input_1, input_rate_1,
                  input_2, input_rate_2,
                  input_3, input_rate_3,
                  input_4, input_rate_4,
                  building,
                  product, product_rate,
                  byproduct, byproduct_rate
                )
  
  # Calculate the ratio (how many times the recipe is to be used for the step)
  ratio = .CalculateRatio(quantity, recipe_row$product_rate)
  
  # Multiply product, byproduct and all inputs by ratio
  recipe_row$product_rate = .RatioTimesColumn(recipe_row$product_rate, ratio)
  recipe_row$byproduct_rate = .RatioTimesColumn(recipe_row$byproduct_rate, ratio)
  
  recipe_row$input_rate_1 = .RatioTimesColumn(recipe_row$input_rate_1, ratio)
  recipe_row$input_rate_2 = .RatioTimesColumn(recipe_row$input_rate_2, ratio)
  recipe_row$input_rate_3 = .RatioTimesColumn(recipe_row$input_rate_3, ratio)
  recipe_row$input_rate_4 = .RatioTimesColumn(recipe_row$input_rate_4, ratio)
  
  # Add ratio-multiplied row as step to crafting tree
  CRAFTING_TREE = .AddRowToCraftingTree(CRAFTING_TREE, recipe_row)
  
  return(CRAFTING_TREE)
}

# Worker function to divide user-desired rate by recipe rate from table
.CalculateRatio = function(desired_rate, recipe_rate) {
  
  return(desired_rate / recipe_rate)
}

# Worker function to multiply a table column by the ratio
.RatioTimesColumn = function(col, ratio) {
  
  return(col * ratio)
}

# Worker function to add calculated step to crafting tree table
.AddRowToCraftingTree = function(CRAFTING_TREE, row) {
  
  return(CRAFTING_TREE %>% add_row(row))
}

# -----------------------------------------------------------------------------
# Recipes table pre-processing
# Add forward, reverse rates
RECIPES = AddForwardRatios(RECIPES)
RECIPES = AddReverseRatios(RECIPES)

# Add bool column for presence/absence of byproducts of the recipe
RECIPES = AddHasByproduct(RECIPES)

# Initialize a tibble for the crafting chain
CRAFTING_TEMPLATE = tibble(recipe=character(),
                           input_1=character(), input_rate_1=numeric(),
                           input_2=character(), input_rate_2=numeric(),
                           input_3=character(), input_rate_3=numeric(),
                           input_4=character(), input_rate_4=numeric(),
                           building=character(),
                           product=character(), product_rate=numeric(),
                           byproduct=character(), byproduct_rate=numeric())

# Make a copy of the template for use
CRAFTING_TREE = CRAFTING_TEMPLATE

# 
ALL_INPUTS_FROM_CRAFTING = c()
TOTAL_INPUTS_FROM_CRAFTING = c()
