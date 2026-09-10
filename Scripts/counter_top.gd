extends StaticBody2D

@onready var interact_component = $InteractComponent
var stored_food: Food = null

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	
func interacted(player):
	# Player holding NO food; counter top IS storing food
	if player.get_current_food_held() == null and stored_food != null:
		player.set_current_food_held(stored_food)
		stored_food = null
		player.get_current_food_held().take_from_counter_top()
	# Player IS holding food; counter top is NOT storing food
	elif player.get_current_food_held() != null and stored_food == null:
		stored_food = player.get_current_food_held()
		player.set_current_food_held(null)
		stored_food.place_on_counter_top(self)
	# Player IS holding food; slot IS storing food
	elif player.get_current_food_held() != null and stored_food != null:
		var temp = player.get_current_food_held()
		player.set_current_food_held(stored_food)
		stored_food = temp
		player.get_current_food_held().take_from_counter_top()
		stored_food.place_on_counter_top(self)
