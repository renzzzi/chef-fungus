extends VBoxContainer

@onready var trash_slot = $TrashSlot
@onready var timer_text = $TimerText
const TRASH_DURATION = 5
var time_left: int = TRASH_DURATION

func _process(delta: float) -> void:
	if trash_slot.get_stored_item() != null:
		timer_text.text = str(time_left)
		if time_left < 0:
			trash_slot.get_stored_item().queue_free()
			trash_slot.set_stored_item(null)
			timer_text.text = str(TRASH_DURATION)
			time_left = TRASH_DURATION
	else:
		timer_text.text = str(TRASH_DURATION)
		time_left = TRASH_DURATION

func _on_timer_timeout() -> void:
	if trash_slot.get_stored_item() != null:
		time_left -= 1
