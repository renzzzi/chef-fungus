class_name Station
extends Node2D

## Station name must be in PascalCase with a space after each word (e.g. "Deep Fryer")
@export var station_name: String
@onready var station_ui_interact_component = get_node("StationUIInteractComponent")

func get_station_ui_interact_component():
	return station_ui_interact_component
	
func get_station_name():
	return station_name
