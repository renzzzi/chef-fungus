class_name HoldableStation
extends Station

# Which the holdable station is
var counter_top: Node2D = null
@onready var holdable_component = $HoldableComponent

func get_holdable_component():
	return holdable_component

func set_counter_top(new_counter_top):
	counter_top = new_counter_top
	
func get_counter_top():
	return counter_top
