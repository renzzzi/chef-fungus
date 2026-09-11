extends Control

@export var station_type: GameEnums.StationType

@onready var food_ui = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/FoodUI
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var station = get_tree().current_scene.get_node(GameEnums.load_station_string[station_type])

func _ready() -> void:
	station.station_interacted.connect(station_interacted)
	
	# Connect signals of every instance of the Station Slot
	if station_type == GameEnums.StationType.FRIDGE:
		for child in $PanelContainer/MarginContainer/VBoxContainer/GridContainer.get_children():
			child.station_slot_interacted.connect(station_slot_interacted)
	elif station_type == GameEnums.StationType.STOVE:
		for child in $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2.get_children():
			if child is Panel:
				child.station_slot_interacted.connect(station_slot_interacted)
	
func station_interacted(ui_active):
	self.visible = ui_active
	# Change food_ui's texture to the food type the player is currently holding
	var texture_to_be_loaded
	if player.get_current_food_held() == null:
		texture_to_be_loaded = GameEnums.FoodType.NONE
	else: 
		texture_to_be_loaded = player.get_current_food_held().get_food_type()
		
	food_ui.texture = GameEnums.load_texture[texture_to_be_loaded]
	
func _process(_delta: float) -> void:
	if player.get_current_food_held() != null:
		food_ui.modulate = GameEnums.load_color[player.get_current_food_held().get_food_freshness()]
	else:
		food_ui.modulate = Color.WHITE

func station_slot_interacted(station_slot):
	if player.get_current_food_held() != null and player.get_current_food_held() is not Food:
		return
	
	# Player holding NO food; slot IS storing food
	if player.get_current_food_held() == null and station_slot.get_stored_food() != null:
		player.set_current_food_held(station_slot.get_stored_food())
		station_slot.set_stored_food(null)
		player.get_current_food_held().unstore_from_station(station)
	# Player IS holding food; slot is NOT storing food
	elif player.get_current_food_held() != null and station_slot.get_stored_food() == null:
		station_slot.set_stored_food(player.get_current_food_held())
		player.set_current_food_held(null)
		station_slot.get_stored_food().store_in_station(station_type)
	# Player IS holding food; slot IS storing food
	elif player.get_current_food_held() != null and station_slot.get_stored_food() != null:
		var temp = player.get_current_food_held()
		player.set_current_food_held(station_slot.get_stored_food())
		station_slot.set_stored_food(temp)
		player.get_current_food_held().unstore_from_fridge(station)
		station_slot.get_stored_food().store_in_fridge(station_type)
	
	# Reload Station's Food UI
	var texture_to_be_loaded
	if player.get_current_food_held() == null: 
		texture_to_be_loaded = GameEnums.FoodType.NONE
	else: 
		texture_to_be_loaded = player.get_current_food_held().get_food_type()
	food_ui.texture = GameEnums.load_texture[texture_to_be_loaded]
