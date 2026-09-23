class_name ToastManager
extends Control

var toast_scene = load("res://Scenes/UI/toast.tscn")
var toast_container: VBoxContainer
var current_toasts: Array[Toast]
const MAX_TOAST = 3

func _ready() -> void:
	toast_container = get_parent().get_node("ToastContainer")
	
	for station in get_tree().get_nodes_in_group("station"):
		station.create_toast.connect(create_toast)


func create_toast(toast_text: String):
	if current_toasts.size() >= MAX_TOAST:
		current_toasts[0].queue_free()
		current_toasts.pop_front()

	var new_toast: Toast = toast_scene.instantiate()

	toast_container.add_child(new_toast)
	new_toast.set_toast_text(toast_text)

	new_toast.toast_finished.connect(_on_toast_finished.bind(new_toast))

	current_toasts.append(new_toast)

func _on_toast_finished(toast: Toast) -> void:
	current_toasts.erase(toast)
