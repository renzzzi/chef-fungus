class_name CombineRecipe
extends Recipe

# INPUT
var required_food_names: Array[String]

# OUTPUTE
var result_food_scene: PackedScene

func _init(required_food_names: Array[String], result_food_scene) -> void:
	self.required_food_names = required_food_names
	required_food_names.sort()
	self.result_food_scene = result_food_scene

func get_required_food_names():
	return required_food_names
	
func get_result_food_scene():
	return result_food_scene
