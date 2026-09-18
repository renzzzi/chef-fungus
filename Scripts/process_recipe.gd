class_name ProcessRecipe
extends Recipe

# INPUT
var station_name: String
var food_name: String

# OUTPUT
var food_processing_method: String # Name of function to call in food.gd

func _init(station_name: String, food_name: String) -> void:
	self.station_name = station_name
	self.food_name = food_name
	
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
