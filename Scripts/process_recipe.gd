class_name ProcessRecipe
extends Recipe

# INPUT
var station_name: String
var food_name: String

# OUTPUT (Either of the two)
var food_processing_method: String # Name of function to call in food.gd
var result_food_scene: PackedScene

func _init(station_name: String, food_name: String, result_food_scene: PackedScene = null) -> void:
	self.station_name = station_name
	self.food_name = food_name
	self.result_food_scene = result_food_scene

	match station_name:
		Constants.BLENDER:
			food_processing_method = "blend"
		Constants.STOVE:
			food_processing_method = "boil"
		Constants.DEEP_FRYER:
			food_processing_method = "fry"
