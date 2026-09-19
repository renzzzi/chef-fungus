class_name Toast
extends Panel

signal toast_finished

@onready var toast_text: Label = $ToastText

func set_toast_text(new_text: String):
	toast_text.text = new_text

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.tween_callback(toast_finished.emit)
	tween.tween_callback(queue_free)
