extends StaticBody2D

@onready var interact_component = $InteractComponent
var placed_food: Food = null

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	
func interacted(player):
	if placed_food == null and player.get_current_food_held() != null:
		placed_food = player.get_current_food_held()
		player.set_current_food_held(null)
		placed_food.place_on_counter_top(self)
	elif placed_food != null and player.get_current_food_held() == null:
		player.set_current_food_held(placed_food)
		placed_food = null
		player.get_current_food_held().take_from_counter_top()
	elif placed_food != null and player.get_current_food_held() != null:
		var temp = player.get_current_food_held()
		player.set_current_food_held(placed_food)
		placed_food = temp
		player.get_current_food_held().take_from_counter_top()
		placed_food.place_on_counter_top(self)
		
