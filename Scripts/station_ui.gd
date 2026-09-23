extends Control

# opened_station.player is used so that station_ui should not have a player reference

var ui_item_image: TextureRect
var pick_up_button: Button
var execute_station_button: Button

## Enter station where this UI is used for
@export var station_name: String

# Reference to the current station currently opened
var opened_station: Station

func _ready():
	# If the station UI is for a holdable station, get pick_up_button reference
	match station_name:
		Constants.FRIDGE, Constants.TRASH_CAN:
			pass
		Constants.SINK:
			execute_station_button = get_specific_control_node(self, "execute_station_button")[0]
			execute_station_button.pressed.connect(execute_station)
		Constants.TABLET:
			pick_up_button = get_specific_control_node(self, "pick_up_button")[0]
			pick_up_button.pressed.connect(pick_up_button_pressed)
		_:
			execute_station_button = get_specific_control_node(self, "execute_station_button")[0]
			execute_station_button.pressed.connect(execute_station)
			pick_up_button = get_specific_control_node(self, "pick_up_button")[0]
			pick_up_button.pressed.connect(pick_up_button_pressed)
	
	ui_item_image = get_specific_control_node(self, "ui_item_image")[0]
	
	
# Searches the whole UI tree to find a specific node that is under a particular group
func get_specific_control_node(node: Node, group_name: String):
	var result: Array[Node] = []
	
	for child in node.get_children():
		if child.is_in_group(group_name):
			result.append(child)
		
		result.append_array(get_specific_control_node(child, group_name))
	
	return result

func execute_station():
	var slots: Array[StationSlot] = []
	match station_name:
		Constants.MIXING_BOWL:
			pass
		Constants.SINK:
			pass
		# For stations that processes food
		_:
			for child in self.find_children("*", "StationSlot"):
				if child.allowed_item_types.has("Food"):
					# If the slot is a cooking_medium_slot
					if child.specific_item != "":
						slots[2] = (child)
						continue
					# If the slot is a food_slot
					slots[0] = (child)
				elif child.allowed_item_types.has("Tool"):
					# If the slot is a tool_slot
					slots[1] = (child)
	
			opened_station.execute_process_food(slots)

func bind_station(station: Station):
	opened_station = station
	opened_station.update_ui_item_image.connect(update_ui_item_image)
	
	for child in self.find_children("*", "StationSlot"):
		child.station_slot_interacted.connect(opened_station.interact_stored_items)

func unbind_station(station: Station):
	if opened_station == null:
		return
		
	if station_name == opened_station.entity_name:
		for child in self.find_children("*", "StationSlot"):
			child.station_slot_interacted.disconnect(opened_station.interact_stored_items)
		opened_station = null
		
func update_ui_item_image(station_slot: StationSlot, player_current_item_held: String, new_slot_item: String):
	if opened_station == null:
		return
	
	if station_name == opened_station.entity_name:
		ui_item_image.texture = Load.load_entity_texture[player_current_item_held]
		station_slot.slot_image.texture = Load.load_entity_texture[new_slot_item]

func station_interacted(ui_active):
	self.visible = ui_active
	
	if opened_station == null:
		return
	
	# Change ui_item_image's texture to the item the player is currently holding
	if opened_station.player.current_item_held == null:
		ui_item_image.texture = Load.load_entity_texture[null]
	else:
		ui_item_image.texture = Load.load_entity_texture[opened_station.player.current_item_held.entity_name]
	
	# Changes the slot image for each slot according to the opened station's stored_items dictionary
	if ui_active:
		for child in self.find_children("*", "StationSlot"):
			# Need to cast child as StationSlot because find_children returns Node
			var station_slot := child as StationSlot
			if opened_station.stored_items.has(child):
				child.slot_image.texture = Load.load_entity_texture[opened_station.stored_items[station_slot].entity_name]

# For HoldableStation only
func pick_up_button_pressed():
	if opened_station == null:
		return
	
	# 1. Clear counter-top placed_item var 
	# 1.5. If the player is holding something, then call interacted() of the counter-top 
	# 2. Call take_from_counter_top
	# 3. Set player's current_item_held var to the picked up holdable station
	# 4. Close UI  
	opened_station.counter_top.placed_item = null
	
	if opened_station.player.current_item_held != null:
		opened_station.counter_top.interacted(opened_station.player)
	
	opened_station.holdable_component.take_from_counter_top()
	opened_station.player.current_item_held = opened_station
	opened_station.station_ui_interact_component.close_ui()
