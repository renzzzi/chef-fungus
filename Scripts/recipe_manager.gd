extends Node

static var recipes: Array[Recipe]

static var sludge_scene = Load.load_food_scene[Constants.SLUDGE]

# Returns a string method name if successful, and sludge food scene if it fails 
static func check_process_recipe(station_name: String, food_name: String):
	for recipe in recipes:
		if recipe is not ProcessRecipe:
			continue
	
		if recipe.get_station_name() == station_name and recipe.get_food_name() == food_name:
			return recipe.food_processing_method
	
	return sludge_scene


static func check_combine_recipe(food_in_slots: Array[Food]) -> PackedScene:
	var input_names: Array[String] = []
	# Store the names of the food in an array
	for food in food_in_slots:
		if food != null:
			input_names.append(food.get_food_name())
	
	input_names.sort()
	
	# Checks all recipes and finds a match
	for recipe in recipes:
		if recipe is not CombineRecipe:
			continue
		
		if recipe.get_required_food_names() == input_names:
			return recipe.get_result_food_scene()
	
	return sludge_scene

# ALL THE RECIPES
func _ready():
	# Process Recipes
	recipes.append(ProcessRecipe.new(Constants.BLENDER, Constants.APPLE))
	
	# Combine Recipes
	recipes.append(CombineRecipe.new([Constants.WATER, Constants.FLOUR], Load.load_food_scene[Constants.DOUGH]))
