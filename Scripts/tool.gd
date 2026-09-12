class_name Tool
extends Node2D

@onready var holdable_component = $HoldableComponent
@export var tool_type: GameEnums.ToolType

func get_holdable_component():
	return holdable_component

func get_tool_type():
	return tool_type
