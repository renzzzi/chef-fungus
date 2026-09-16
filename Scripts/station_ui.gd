extends Control

@onready var station: Station = get_parent()

@onready var item_ui = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/ItemUI
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

# After nesting the UI within the Station scene, _ready of UI runs first than
# Station _ready so var station is null, it needs to be deferred by at one call
func _ready() -> void:
	call_deferred("_initialize")
	
func _initialize() -> void:
	station.get_station_ui_interact_component().station_interacted.connect(station_interacted)

	# Connect signals of every instance of the Station Slot
	if station.get_station_name() == "Fridge":
		for child in $PanelContainer/MarginContainer/VBoxContainer/GridContainer.get_children():
			child.station_slot_interacted.connect(station_slot_interacted)
	elif station.get_station_name() == "Stove":
		var foodSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/StoveFoodSlot
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/StoveToolSlot
		var waterSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer3/StoveWaterSlot
		foodSlot.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		waterSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/StoveFoodResultSlot
	elif station.get_station_name() == "Blender":
		var foodSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/BlenderFoodSlot
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/BlenderToolSlot
		foodSlot.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/BlenderFoodResultSlot
	elif station.get_station_name() == "Oven":
		var foodSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/OvenFoodSlot
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/OvenToolSlot
		foodSlot.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/OvenFoodResultSlot
	elif station.get_station_name() == "ChoppingBoard":
		var foodSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/ChoppingBoardFoodSlot
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/ChoppingBoardToolSlot
		foodSlot.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/ChoppingBoardFoodResultSlot
	elif station.get_station_name() == "DeepFryer":
		var foodSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/DeepFryerFoodSlot
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/DeepFryerToolSlot
		var oilSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer3/DeepFryerOilSlot
		foodSlot.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		oilSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/DeepFryerFoodResultSlot
	elif station.get_station_name() == "MixingBowl":
		var foodSlot1 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer/MixingBowlFoodSlot
		var foodSlot2 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer2/MixingBowlFoodSlot2
		var foodSlot3 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer3/MixingBowlFoodSlot3
		var toolSlot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/MixingBowlToolSlot
		foodSlot1.station_slot_interacted.connect(station_slot_interacted)
		foodSlot2.station_slot_interacted.connect(station_slot_interacted)
		foodSlot3.station_slot_interacted.connect(station_slot_interacted)
		toolSlot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Button
		var food_result_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/MixingBowlFoodResultSlot



func station_interacted(ui_active):
	self.visible = ui_active
	# Change food_ui's texture to the food type the player is currently holding
	if player.get_current_item_held() == null:
		item_ui.texture = Load.load_food_texture[null]
	elif player.get_current_item_held() is HoldableStation:
		item_ui.texture = Load.load_holdable_station_texture[player.get_current_item_held().get_station_name()]
	elif player.get_current_item_held() is Tool:
		item_ui.texture = Load.load_tool_texture[player.get_current_item_held().get_tool_name()]
	elif player.get_current_item_held() is Food: 
		item_ui.texture = Load.load_food_texture[player.get_current_item_held().get_food_name()]
	
func _process(_delta: float) -> void:
	if player.get_current_item_held() != null and player.get_current_item_held() is Food:
		item_ui.modulate = Load.load_color[player.get_current_item_held().get_food_freshness()]
	else:
		item_ui.modulate = Color.WHITE

func station_slot_interacted(station_slot):
	# This block checks if the current item the player is holding matches the item type
	# that the station slot is allowed to store
	if player.get_current_item_held() is Food:
		if !station_slot.check_allowed_item_types(player.get_current_item_held()):
			return
	elif player.get_current_item_held() is Tool:
		if !station_slot.check_allowed_item_types(player.get_current_item_held()):
			return
	elif player.get_current_item_held() is HoldableStation:
		if !station_slot.check_allowed_item_types(player.get_current_item_held()):
			return
	
	# Player holding NO food; slot IS storing food
	if player.get_current_item_held() == null and station_slot.get_stored_item() != null:
		player.set_current_item_held(station_slot.get_stored_item())
		station_slot.set_stored_item(null)
		player.get_current_item_held().get_holdable_component().unstore_from_station(station)
	# Player IS holding food; slot is NOT storing food
	elif player.get_current_item_held() != null and station_slot.get_stored_item() == null:
		station_slot.set_stored_item(player.get_current_item_held())
		player.set_current_item_held(null)
		station_slot.get_stored_item().get_holdable_component().store_in_station(station.get_station_name())
	# Player IS holding food; slot IS storing food
	elif player.get_current_item_held() != null and station_slot.get_stored_item() != null:
		var temp = player.get_current_item_held()
		player.set_current_item_held(station_slot.get_stored_item())
		station_slot.set_stored_item(temp)
		player.get_current_item_held().get_holdable_component().unstore_from_station(station)
		station_slot.get_stored_item().get_holdable_component().store_in_station(station.get_station_name())
	
	# Reload Station's Food UI
	if player.get_current_item_held() == null: 
		item_ui.texture = Load.load_food_texture[null]
	else: 
		if player.get_current_item_held() is Food:
			item_ui.texture = Load.load_food_texture[player.get_current_item_held().get_food_name()]
		elif player.get_current_item_held() is Tool:
			item_ui.texture = Load.load_tool_texture[player.get_current_item_held().get_tool_name()]
		elif player.get_current_item_held() is HoldableStation:
			item_ui.texture = Load.load_holdable_station_texture[player.get_current_item_held().get_station_name()]
	

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
	
	
