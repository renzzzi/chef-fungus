class_name Station
extends Node2D

@export var station_type: GameEnums.StationType
@onready var station_ui_interact_component = $StationUIInteractComponent

func get_station_ui_interact_component():
	return station_ui_interact_component
	
func get_station_type():
	return station_type
