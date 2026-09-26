class_name ShopSlot
extends StationSlot

var mouse_hold_time_elapsed = 0.0
const HOLD_DURATION = 3.0
var hold_completed = false

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !hold_completed:
		mouse_hold_time_elapsed += delta
		
		if mouse_hold_time_elapsed >= HOLD_DURATION:
			station_slot_interacted.emit(self)
			hold_completed = true
	else:
		mouse_hold_time_elapsed = 0.0
		hold_completed = false

func _gui_input(event: InputEvent) -> void:
	pass
