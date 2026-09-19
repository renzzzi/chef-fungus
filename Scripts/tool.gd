class_name Tool
extends Node2D

@onready var holdable_component = $HoldableComponent
## Tool name must be in PascalCase with a space after each word (e.g. "Sheet Pan")
@export var tool_name: String
var is_dirty = false
var uses_left = 2

func decrement_uses_left():
	uses_left -= 1

func get_uses_left():
	return uses_left

func set_is_dirty(is_dirty):
	self.is_dirty = is_dirty
	modulate = Load.load_color[is_dirty]

func get_holdable_component():
	return holdable_component

func get_tool_name():
	return tool_name
	
func get_is_dirty():
	return is_dirty
