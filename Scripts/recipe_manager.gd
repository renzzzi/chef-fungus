extends Node

static var recipes: Array[Recipe] = []

static var sludge_scene: PackedScene

# Returns a string method name or food scene if successful, and sludge food scene if it fails 
static func check_process_recipe(station_name: String, food_name: String):
	for recipe in recipes:
		if recipe is not ProcessRecipe:
			continue
	
		if recipe.station_name == station_name and recipe.food_name == food_name:
			if recipe.result_food_scene != null:
				return recipe.result_food_scene
			else:
				return recipe.food_processing_method
	
	return sludge_scene


static func check_combine_recipe(food_in_slots: Array[Food]) -> PackedScene:
	var input_names: Array[String] = []
	# Store the names of the food in an array
	for food in food_in_slots:
		if food != null:
			input_names.append(food.food_name)
	
	input_names.sort()
	
	# Checks all recipes and finds a match
	for recipe in recipes:
		if recipe is not CombineRecipe:
			continue
		
		if recipe.required_food_names == input_names:
			return recipe.result_food_scene
	
	return sludge_scene

# ALL THE RECIPES
func _ready():
	sludge_scene = Load.load_entity_scene[Constants.SLUDGE]
	
	# Process Recipes
	recipes.append(ProcessRecipe.new(Constants.BLENDER, Constants.APPLE))
	recipes.append(ProcessRecipe.new(Constants.OVEN, Constants.DOUGH, Load.load_entity_scene[Constants.BREAD]))
	
	# Combine Recipes
	recipes.append(CombineRecipe.new([Constants.WATER, Constants.FLOUR], Load.load_entity_scene[Constants.DOUGH]))
