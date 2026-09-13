extends Node

func check_recipe(food_in_bowl: Array):
	var all_tags: Array[String] = []
	var food_types: Array[GameEnums.FoodType]
	for food in food_in_bowl:
		all_tags.append_array(food.tags)
		food_types.append(food.get_food_type())
		
	if all_tags.has()

#func has_tags(basket: Array[String], required: Array) -> bool:
	#for req in required:
		#if not basket.has(req):
			#return false
	#return true
