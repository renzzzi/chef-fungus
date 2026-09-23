class_name Tool
extends Node2D

@onready var holdable_component = $HoldableComponent
## Tool name must be in PascalCase with a space after each word (e.g. "Sheet Pan")
@export var entity_name: String
var is_dirty = false
var uses_left = 2

func set_is_dirty(is_dirty):
	self.is_dirty = is_dirty
	modulate = Load.load_color[is_dirty]
