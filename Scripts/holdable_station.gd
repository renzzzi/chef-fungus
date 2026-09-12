class_name HoldableStation
extends Station

# Which the holdable station is
var counter_top: Node2D = null

func set_counter_top(new_counter_top):
	counter_top = new_counter_top
	
func get_counter_top():
	return counter_top
