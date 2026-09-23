class_name Station
extends Node2D

## Station name must be in PascalCase with a space after each word (e.g. "Deep Fryer")
@export var entity_name: String
@onready var station_ui_interact_component = $StationUIInteractComponent
var stored_items: Dictionary[StationSlot, Variant] = {null: null}
@onready var player = get_tree().get_first_node_in_group("player")
signal create_toast(message: String)

signal update_ui_item_image(station_slot: StationSlot, player_current_item_held: String, new_slot_item: String)

func interact_stored_items(station_slot: StationSlot):
	if player.current_item_held == null:
		player.current_item_held = stored_items[station_slot]
		if stored_items.has(station_slot):
			stored_items.erase(station_slot)
			update_ui_item_image.emit(station_slot, player.current_item_held.entity_name, stored_items[station_slot].entity_name)
	else:
		# Checks if the slot is allowed to store what the player is holding
		var allowed = false
		if ((station_slot.allowed_item_types.has("Food") and player.current_item_held is Food) or
		(station_slot.allowed_item_types.has("Tool") and player.current_item_held is Tool) or
		(station_slot.allowed_item_types.has("HoldableStation") and player.current_item_held is HoldableStation)):
			allowed = true
		
		# Swaps the player held item to the slot and vice versa
		if allowed:
			var temp = player.current_item_held
			player.current_item_held = stored_items[station_slot]
			if temp == null:
				stored_items.erase(station_slot)
			else:
				stored_items[station_slot] = temp
			update_ui_item_image.emit(station_slot, player.current_item_held.entity_name, stored_items[station_slot].entity_name)
	

func execute_process_food(slots: Array[StationSlot] = []):
	# Resize if slots argument has less elements than total amount of station slots
	var total_station_slots = 3
	if slots.size() != total_station_slots:
		slots.resize(total_station_slots)
	
	# slots[0] = food_slot
	# slots[1] = tool_slot
	# slots[2] = cooking_medium_slot (e.g. Stove has a slot for "Water")
	
	if !stored_items.has(slots[0]):
		create_toast.emit("Place in food")
		return
	
	if !stored_items.has(slots[1]):
		create_toast.emit("Place in the appropriate tool")
		return
	
	if stored_items[slots[1]].uses_left < 1:
		create_toast.emit("The tool is broken, buy a new one")
		return
	
	if stored_items[slots[1]].is_dirty:
		create_toast.emit("The tool is dirty, get it cleaned")
		return
	
	var result = RecipeManager.check_process_recipe(self.entity_name, stored_items[slots[0]].entity_name)
	
	if slots[2] != null:
		if stored_items.has(slots[2]):
			stored_items[slots[2]].queue_free()
			stored_items.erase(slots[2])
	
	# If result is a new food scene
	if result is PackedScene:
		# instantiate() -> add to tree -> delete food in slot -> add sludge to slot -> initiate store station for sludge
		var result_food = result.instantiate()
		get_tree().get_node("Kitchen").add_child(result_food)
		stored_items[slots[0]].queue_free()
		stored_items[slots[0]] = result_food
		stored_items[slots[0]].holdable_component.store_in_station(self.entity_name)
	# If result is a string method
	else:
		stored_items[slots[0]].call(result)
		
	stored_items[slots[1]].set_is_dirty(true)
	stored_items[slots[1]].uses_left -= 1
		
func execute_combine_food(slots: Array[StationSlot] = []):
	# Resize if slots argument has less elements than total amount of station slots
	var total_station_slots = 4
	if slots.size() != total_station_slots:
		slots.resize(total_station_slots)
	
	# slots[0] = food_slot
	# slots[1] = food_slot
	# slots[2] = food_slot
	# slots[3] = tool_slot
	
	# Checks if the food slots has at least 2 of them out of 3 which are storing food
	var null_count = 0
	# -2 for index and to only include food slots
	for i in range(0, total_station_slots - 2):
		if !stored_items.has(slots[i]): 
			null_count += 1
	
	if null_count > 1:
		create_toast.emit("Place in at least 2 food")
		return
	
	if !stored_items.has(slots[3]):
		create_toast.emit("Place in the appropriate tool")
		return
	
	if stored_items[slots[3]].uses_left < 1:
		create_toast.emit("The tool is broken, buy a new one")
		return
	
	if stored_items[slots[3]].is_dirty:
		create_toast.emit("The tool is dirty, get it cleaned")
		return
	
	# Get the food in each slot and stores it in another array
	var food_in_slots: Array[Food]
	for slot in slots:
		if stored_items.has(slot):
			food_in_slots.append(stored_items[slot])
	
	var result = RecipeManager.check_combine_recipe(food_in_slots)
	var result_food = result.instantiate()
	get_tree().current_scene.add_child(result_food)
	
	# These blocks are to clear each slots and put the result food in food_slots[0]
	if stored_items.has(slots[0]): 
		stored_items[slots[0]].queue_free()
		stored_items[slots[0]] = result_food
		
	if stored_items.has(slots[1]): 
		stored_items[slots[1]].queue_free()
		stored_items[slots[1]] = null
	
	if stored_items.has(slots[2]): 
		stored_items[slots[2]].queue_free()
		stored_items[slots[2]] = null
	
	# Then trigger the store_in_station of the result food
	stored_items[slots[0]].holdable_component.store_in_station(self.entity_name)
	stored_items[slots[3]].set_is_dirty(true)
	stored_items[slots[3]].uses_left -= 1
	
func execute_sink(slots: Array[StationSlot] = []):
	# Resize if slots argument has less elements than total amount of station slots
	var total_station_slots = 7
	if slots.size() != total_station_slots:
		slots.resize(total_station_slots)
	
	# slots[0] = tool_slot
	# slots[1] = tool_slot
	# slots[2] = tool_slot
	# slots[3] = tool_slot
	# slots[4] = tool_slot
	# slots[5] = tool_slot
	# slots[6] = tool_slot specifically for "Sponge"
	
	# Checks if the to-clean tool slots has at least 1 of them out of 6 which are storing tools
	var null_count = 0
	# -2 for index and to only include to-clean tool slots
	for i in range(0, total_station_slots - 2):
		if !stored_items.has(slots[i]): 
			null_count += 1
	
	if null_count > 5:
		create_toast.emit("Place in at least 1 tool to clean")
		return
	
	if !stored_items.has(slots[6]):
		create_toast.emit("Place in the appropriate cleaning tool")
		return
		
	if stored_items[slots[6]].uses_left < 1:
		create_toast.emit("The cleaning tool is broken, buy a new one")
		return
		
	for i in range(0, total_station_slots - 1):
		if stored_items.has(slots[i]):
			stored_items[slots[i]].set_is_dirty(false)
	
	stored_items[slots[6]].uses_left -= 1
