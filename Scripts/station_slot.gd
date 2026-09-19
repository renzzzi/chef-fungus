class_name StationSlot
extends Panel

@onready var food_image = $FoodImage

# An array where each item is picked from the ItemType dropdown:
# I just resorted to a string cause the other

@export_category("For more info please read the tooltip")
## Allowed string values = ["Food", "Tool", "HoldableStation"]
@export var allowed_item_types: Array[String] = []
@export_category("For more info please read the tooltip")
## Used if the slot only accepts a specific item (e.g. "Sheet Pan")
@export var specific_item: String = ""
var stored_item = null
signal station_slot_interacted(station_slot)

func set_stored_item(new_stored_item):
	stored_item = new_stored_item
	
func get_stored_item():
	return stored_item
	
func get_allowed_item_types():
	return allowed_item_types
	
func get_specific_item():
	return specific_item
	
func check_allowed_item_types(player_current_item_held) -> bool:
	var is_allowed: bool = false
	if player_current_item_held is Food and allowed_item_types.has("Food"):
		is_allowed = true
	elif player_current_item_held is Tool and allowed_item_types.has("Tool"):
		is_allowed = true
	elif player_current_item_held is HoldableStation and allowed_item_types.has("HoldableStation"):
		is_allowed = true
	
	if specific_item != "":
		if player_current_item_held is Food:
			if player_current_item_held.get_food_name() != specific_item:
				is_allowed = false
		elif player_current_item_held is Tool:
			if player_current_item_held.get_tool_name() != specific_item:
				is_allowed = false
		elif player_current_item_held is HoldableStation:
			if player_current_item_held.get_station_name() != specific_item:
				is_allowed = false
		else:
			is_allowed = false
	
	if player_current_item_held == null:
		is_allowed = true
		
	return is_allowed
	
func _process(_delta: float) -> void:
	if stored_item == null:
		food_image.visible = false
	else:
		if stored_item is Food:
			food_image.modulate = Load.load_color[stored_item.get_food_freshness()]
			food_image.texture = Load.load_food_texture[stored_item.get_food_name()]
		elif stored_item is Tool:
			food_image.modulate = Load.load_color[stored_item.get_is_dirty()]
			food_image.texture = Load.load_tool_texture[stored_item.get_tool_name()]
		elif stored_item is HoldableStation:
			food_image.texture = Load.load_holdable_station_texture[stored_item.get_station_name()]
		food_image.visible = true

func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed() and 
		get_global_rect().has_point(get_global_mouse_position())
	):
		station_slot_interacted.emit(self)
