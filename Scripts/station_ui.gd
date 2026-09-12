extends Control

@export var station_type: GameEnums.StationType

@onready var item_ui = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/ItemUI
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var station = get_tree().current_scene.get_node(GameEnums.load_station_string[station_type])

func _ready() -> void:
	station.get_station_ui_interact_component().station_interacted.connect(station_interacted)

	# Connect signals of every instance of the Station Slot
	if station_type == GameEnums.StationType.FRIDGE:
		for child in $PanelContainer/MarginContainer/VBoxContainer/GridContainer.get_children():
			child.station_slot_interacted.connect(station_slot_interacted)
	elif station_type == GameEnums.StationType.STOVE:
		for child in $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2.get_children():
			if child is Panel:
				child.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
	elif station_type == GameEnums.StationType.BLENDER:
		var slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/BlenderSlot
		slot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
	
func station_interacted(ui_active):
	self.visible = ui_active
	# Change food_ui's texture to the food type the player is currently holding
	if player.get_current_item_held() == null:
		item_ui.texture = GameEnums.load_food_texture[GameEnums.FoodType.NONE]
	elif player.get_current_item_held() is HoldableStation:
		item_ui.texture = GameEnums.load_holdable_station_texture[player.get_current_item_held().get_station_type()]
	elif player.get_current_item_held() is Tool:
		item_ui.texture = GameEnums.load_tool_texture[player.get_current_item_held().get_tool_type()]
	elif player.get_current_item_held() is Food: 
		item_ui.texture = GameEnums.load_food_texture[player.get_current_item_held().get_food_type()]
	
func _process(_delta: float) -> void:
	if player.get_current_item_held() != null and player.get_current_item_held() is Food:
		item_ui.modulate = GameEnums.load_color[player.get_current_item_held().get_food_freshness()]
	else:
		item_ui.modulate = Color.WHITE

func station_slot_interacted(station_slot):
	if player.get_current_item_held() != null and player.get_current_item_held() is not Food:
		return
	
	# Player holding NO food; slot IS storing food
	if player.get_current_item_held() == null and station_slot.get_stored_food() != null:
		player.set_current_item_held(station_slot.get_stored_food())
		station_slot.set_stored_food(null)
		player.get_current_item_held().get_holdable_component().unstore_from_station(station)
	# Player IS holding food; slot is NOT storing food
	elif player.get_current_item_held() != null and station_slot.get_stored_food() == null:
		station_slot.set_stored_food(player.get_current_item_held())
		player.set_current_item_held(null)
		station_slot.get_stored_food().get_holdable_component().store_in_station(station_type)
	# Player IS holding food; slot IS storing food
	elif player.get_current_item_held() != null and station_slot.get_stored_food() != null:
		var temp = player.get_current_item_held()
		player.set_current_item_held(station_slot.get_stored_food())
		station_slot.set_stored_food(temp)
		player.get_current_item_held().get_holdable_component().unstore_from_station(station)
		station_slot.get_stored_food().get_holdable_component().store_in_station(station_type)
	
	# Reload Station's Food UI
	var texture_to_be_loaded
	if player.get_current_item_held() == null: 
		texture_to_be_loaded = GameEnums.FoodType.NONE
	else: 
		texture_to_be_loaded = player.get_current_item_held().get_food_type()
	item_ui.texture = GameEnums.load_food_texture[texture_to_be_loaded]

func pick_up_button_pressed():
	# 1. Clear counter-top placed_item var 
	# 1.5. If the player is holding something, then call interacted() of the counter-top 
	# 2. Call take_from_counter_top
	# 3. Set player's current_item_held var to the picked up holdable station
	# 4. Close UI  
	station.get_counter_top().clear_placed_item()
	
	if player.get_current_item_held() != null:
		station.get_counter_top().interacted(player)
	
	station.get_holdable_component().take_from_counter_top()
	player.set_current_item_held(station)
	station.get_station_ui_interact_component().close_ui()
	
	
