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
	if station.get_station_name() == Constants.FRIDGE:
		for child in $PanelContainer/MarginContainer/VBoxContainer/GridContainer.get_children():
			child.station_slot_interacted.connect(station_slot_interacted)
	elif station.get_station_name() == Constants.MIXING_BOWL:
		var food_slot_1 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer/FoodSlot
		var food_slot_2 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer2/FoodSlot
		var food_slot_3 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/VBoxContainer3/FoodSlot
		var tool_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/ToolSlot
		food_slot_1.station_slot_interacted.connect(station_slot_interacted)
		food_slot_2.station_slot_interacted.connect(station_slot_interacted)
		food_slot_3.station_slot_interacted.connect(station_slot_interacted)
		tool_slot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
		
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/ExecuteStationButton
		execute_station_button.pressed.connect(
			func():
				execute_combine_food([food_slot_1, food_slot_2, food_slot_3], tool_slot)
		)
	else:
		var food_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer/FoodSlot
		var tool_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer2/ToolSlot
		food_slot.station_slot_interacted.connect(station_slot_interacted)
		tool_slot.station_slot_interacted.connect(station_slot_interacted)
		var pick_up_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PickUp
		pick_up_button.pick_up_button_pressed.connect(pick_up_button_pressed)
	
		var cooking_medium_slot = null
		if (station.get_station_name() == Constants.DEEP_FRYER or 
			station.get_station_name() == Constants.STOVE):
			cooking_medium_slot = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/HBoxContainer/VBoxContainer3/CookingMediumSlot
			cooking_medium_slot.station_slot_interacted.connect(station_slot_interacted)
		
		var execute_station_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Control/VBoxContainer/ExecuteStationButton
		execute_station_button.pressed.connect(
			func():
				execute_process_food(food_slot, tool_slot, cooking_medium_slot)
		)
			
		

func execute_process_food(food_slot: StationSlot, tool_slot: StationSlot, cooking_medium_slot: StationSlot = null):
	if food_slot.get_stored_item() == null or tool_slot.get_stored_item() == null:
		return
	
	var result = RecipeManager.check_process_recipe(station.get_station_name(), food_slot.get_stored_item().get_food_name())
	
	if cooking_medium_slot != null:
		cooking_medium_slot.get_stored_item().queue_free()
		cooking_medium_slot.set_stored_item(null)
	
	# If result is a new food scene
	if result is PackedScene:
		# instantiate() -> add to tree -> delete food in slot -> add sludge to slot -> initiate store station for sludge
		var result_food = result.instantiate()
		get_tree().current_scene.add_child(result_food)
		food_slot.get_stored_item().queue_free()
		food_slot.set_stored_item(result_food)
		food_slot.get_stored_item().get_holdable_component().store_in_station(station.get_station_name())
	# If result is a string method
	else:
		food_slot.get_stored_item().call(result)
		
func execute_combine_food(food_slots: Array[StationSlot], tool_slot: StationSlot):
	# Checks if food_slots has at least 2 slots that are storing food
	var null_count = 0
	for slot in food_slots:
		if slot.get_stored_item() == null:
			null_count += 1
			
	if null_count > 1 or tool_slot.get_stored_item() == null:
		return
	
	# Get the food in each slot and stores it in another array
	var food_in_slots: Array[Food]
	for slot in food_slots:
		food_in_slots.append(slot.get_stored_item())
	
	var result = RecipeManager.check_combine_recipe(food_in_slots)
	var result_food = result.instantiate()
	get_tree().current_scene.add_child(result_food)
	
	# These blocks are to clear each slots and put the result food in slot 0
	if food_slots[0].get_stored_item() != null: 
		food_slots[0].get_stored_item().queue_free()
		food_slots[0].set_stored_item(result_food)
		
	if food_slots[1].get_stored_item() != null: 
		food_slots[1].get_stored_item().queue_free()
		food_slots[1].set_stored_item(null)
	
	if food_slots[2].get_stored_item() != null: 
		food_slots[2].get_stored_item().queue_free()
		food_slots[2].set_stored_item(null)
	
	# Then trigger the store_in_station of the result food
	food_slots[0].get_stored_item().get_holdable_component().store_in_station(station.get_station_name())
	

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
