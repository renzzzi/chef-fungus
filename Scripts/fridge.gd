extends StaticBody2D

@onready var interact_component = $InteractComponent

signal fridge_interacted(ui_active: bool)
var ui_active = false

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	
func interacted(_player):
	# Toggle ui_active then send ui_active upon interaction
	ui_active = !ui_active
	fridge_interacted.emit(ui_active)
