extends Node2D

@onready var interact_component = $"../InteractComponent"
@onready var station = self.get_parent()

signal station_interacted(ui_active: bool)
var ui_active = false

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	
func interacted(_player):
	if station is HoldableStation:
		if station.get_counter_top() == null:
			return
		
	ui_active = !ui_active
	station_interacted.emit(ui_active)
	
# For holdable stations
func open_ui():
	if !ui_active:
		ui_active = true
	station_interacted.emit(ui_active)

func close_ui():
	if ui_active:
		ui_active = false
	station_interacted.emit(ui_active)
