class_name Station
extends Node2D

## Station name must be in PascalCase with a space after each word (e.g. "Deep Fryer")
@export var entity_name: String
@onready var station_ui_interact_component = $StationUIInteractComponent
var stored_items: Dictionary[StationSlot, Variant] = {}
@onready var player = get_tree().get_first_node_in_group("player")
signal create_toast(message: String)

signal update_ui_item_image(station_slot: StationSlot, player_current_item_held: String, new_slot_item: String)
signal update_ui_freshness(station_slot: StationSlot, new_freshness: Food.Freshness)

func on_food_freshness_changed(food: Food, new_freshness: Food.Freshness):
	# Food doesn't know its slot, but the station does
	var slot = stored_items.find_key(food)
	if slot != null:
		update_ui_freshness.emit(slot, new_freshness)

func store(slot: StationSlot, item) -> void:
	stored_items[slot] = item
	item.holdable_component.store_in_station(entity_name)
	if item is Food:
		item.freshness_changed.connect(on_food_freshness_changed)
		update_ui_freshness.emit(slot, item.freshness)
	else:
		update_ui_freshness.emit(slot, Food.Freshness.FRESH)

func take(slot: StationSlot):
	var item = stored_items.get(slot)
	stored_items.erase(slot)
	if item is Food and item.freshness_changed.is_connected(on_food_freshness_changed):
		item.freshness_changed.disconnect(on_food_freshness_changed)
	item.holdable_component.unstore_from_station(self)
	return item

func interact_stored_items(station_slot: StationSlot):
	if player.current_item_held == null and stored_items.get(station_slot) == null:
		return
	
	# Player <- Slot
	if player.current_item_held == null:
		player.current_item_held = take(station_slot)
		update_ui_item_image.emit(station_slot, name_of(player.current_item_held), name_of(stored_items.get(station_slot)))
	else:
		# Checks if the slot is allowed to store what the player is holding
		var allowed = false
		if ((station_slot.allowed_item_types.has("Food") and player.current_item_held is Food) or
		(station_slot.allowed_item_types.has("Tool") and player.current_item_held is Tool) or
		(station_slot.allowed_item_types.has("HoldableStation") and player.current_item_held is HoldableStation)):
			allowed = true
		
		if station_slot.specific_item != "":
			if not station_slot.specific_item == player.current_item_held.entity_name:
				allowed = false
		
		# Swaps the player held item to the slot and vice versa
		# Player -> Slot
		if allowed:
			# Player -> Slot
			if stored_items.get(station_slot) == null:
				store(station_slot, player.current_item_held)
				player.current_item_held = null
			# Player <-> Slot
			else:
				var incoming = player.current_item_held
				player.current_item_held = take(station_slot)
				store(station_slot, incoming)
			update_ui_item_image.emit(station_slot, name_of(player.current_item_held), name_of(stored_items.get(station_slot)))
		else:
			create_toast.emit("You can't store that here.")

# Helper function
func name_of(item):
	return item.entity_name if item != null else null

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
	
	var result = RecipeManager.check_process_recipe(self.entity_name, stored_items.get(slots[0]).entity_name)

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
