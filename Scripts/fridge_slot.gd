extends Panel

@onready var food_image = $FoodImage
var stored_food: Food = null
signal fridge_slot_interacted(fridge_slot)

func set_stored_food(new_stored_food):
	stored_food = new_stored_food
	
func get_stored_food():
	return stored_food

func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed() and 
		get_global_rect().has_point(get_global_mouse_position())
	):
		fridge_slot_interacted.emit(self)

		if stored_food == null:
			food_image.visible = false
		else:
			food_image.texture = GameEnums.load_texture[stored_food.get_food_type()]
			food_image.visible = true
