extends Button

signal pick_up_button_pressed()

func _on_pressed() -> void:
	pick_up_button_pressed.emit()
