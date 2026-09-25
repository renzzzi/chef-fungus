extends VBoxContainer

@onready var trash_can_station = get_tree().get_first_node_in_group("trash_can")
@onready var trash_slot = $TrashSlot
@onready var timer_text = $TimerText
const TRASH_DURATION = 5
var time_left: int = TRASH_DURATION

func _process(delta: float) -> void:
	if trash_can_station.stored_items.has(trash_slot):
		timer_text.text = str(time_left)
		if time_left < 0:
			trash_can_station.stored_items[trash_slot].queue_free()
			trash_can_station.stored_items.erase(trash_slot)
			trash_can_station.update_ui_slot_image.emit(trash_slot, trash_can_station.stored_items.get(trash_slot))
			timer_text.text = str(TRASH_DURATION)
			time_left = TRASH_DURATION
	else:
		timer_text.text = str(TRASH_DURATION)
		time_left = TRASH_DURATION

func _on_timer_timeout() -> void:
	if trash_can_station.stored_items.has(trash_slot):
		time_left -= 1
