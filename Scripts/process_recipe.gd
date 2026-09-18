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

func get_station_name():
	return station_name

func get_food_name():
	return food_name
	
func get_food_processing_method():
	return food_processing_method

func get_result_food_scene():
	return result_food_scene
