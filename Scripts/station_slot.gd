class_name StationSlot
extends Panel

@onready var slot_image = $SlotImage

# An array where each item is picked from the ItemType dropdown:
# I just resorted to a string cause the other
@export_category("For more info please read the tooltip")
## Allowed string values = ["Food", "Tool", "HoldableStation"]
@export var allowed_item_types: Array[String] = []

@export_category("For more info please read the tooltip")
## Used if the slot only accepts a specific item (e.g. "Sheet Pan", "Water")
@export var specific_item: String = ""
signal station_slot_interacted(station_slot: StationSlot)

func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed() and 
		get_global_rect().has_point(get_global_mouse_position())
	):
		station_slot_interacted.emit(self)
