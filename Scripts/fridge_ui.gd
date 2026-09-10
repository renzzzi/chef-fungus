extends Control

@onready var food_ui = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/FoodUI
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var fridge = get_tree().current_scene.get_node("Fridge")

func _ready() -> void:
	fridge.fridge_interacted.connect(fridge_interacted)
	
	# Connect signals of every instance of the Fridge Slot
	for fridge_slot in $PanelContainer/MarginContainer/VBoxContainer/GridContainer.get_children():
		fridge_slot.fridge_slot_interacted.connect(fridge_slot_interacted)
	
func fridge_interacted(ui_active):
	self.visible = ui_active
	# Change food_ui's texture to the food type the player is currently holding
	var texture_to_be_loaded
	if player.get_current_food_held() == null: texture_to_be_loaded = GameEnums.FoodType.NONE
	else: texture_to_be_loaded = player.get_current_food_held().get_food_type()
	food_ui.texture = GameEnums.load_texture[texture_to_be_loaded]
	
func fridge_slot_interacted(fridge_slot):
	if player.get_current_food_held() != null and player.get_current_food_held() is not Food:
		return
	
	# Player holding NO food; slot IS storing food
	if player.get_current_food_held() == null and fridge_slot.get_stored_food() != null:
		player.set_current_food_held(fridge_slot.get_stored_food())
		fridge_slot.set_stored_food(null)
		player.get_current_food_held().unstore(fridge)
	# Player IS holding food; slot is NOT storing food
	elif player.get_current_food_held() != null and fridge_slot.get_stored_food() == null:
		fridge_slot.set_stored_food(player.get_current_food_held())
		player.set_current_food_held(null)
		fridge_slot.get_stored_food().store()
	# Player IS holding food; slot IS storing food
	elif player.get_current_food_held() != null and fridge_slot.get_stored_food() != null:
		var temp = player.get_current_food_held()
		player.set_current_food_held(fridge_slot.get_stored_food())
		fridge_slot.set_stored_food(temp)
		player.get_current_food_held().unstore(fridge)
		fridge_slot.get_stored_food().store()
	
	# Reload Fridge's Food UI
	var texture_to_be_loaded
	if player.get_current_food_held() == null: texture_to_be_loaded = GameEnums.FoodType.NONE
	else: texture_to_be_loaded = player.get_current_food_held().get_food_type()
	food_ui.texture = GameEnums.load_texture[texture_to_be_loaded]
