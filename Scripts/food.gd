class_name Food
extends Node2D

@export var food_type: GameEnums.FoodType
@onready var holdable_component = $HoldableComponent
var stored_in := GameEnums.StationType.NONE
var tags: Array[String] = []

# How long it takes in second before food changes freshness
var expiry_counter: float = 0.0
@export var STALE: int
@export var SPOILED: int

func _ready():
	tags.append(Tags.FRESH)

func _on_timer_timeout() -> void:
	# Slows down expiry based on where food is stored in
	match stored_in:
		GameEnums.StationType.FRIDGE:
			expiry_counter += 0.1
		GameEnums.StationType.OVEN, GameEnums.StationType.BLENDER:
			expiry_counter += 0.6
		GameEnums.StationType.COUNTERTOP, GameEnums.StationType.STOVE, GameEnums.StationType.MIXING_BOWL, GameEnums.StationType.DEEP_FRYER:
			expiry_counter += 0.75
		GameEnums.StationType.NONE:
			expiry_counter += 1
	
	# Changed food_freshness and tint
	if expiry_counter >= STALE and expiry_counter < SPOILED:
		if !tags.has(Tags.STALE):
			tags.erase(Tags.FRESH)
			tags.append(Tags.STALE)
			modulate = Load.load_color[Tags.STALE]
	elif expiry_counter >= SPOILED:
		if !tags.has(Tags.SPOILED):
			tags.erase(Tags.STALE)
			tags.append(Tags.SPOILED)
			modulate = Load.load_color[Tags.SPOILED]

func get_food_type():
	return food_type
	
func get_holdable_component():
	return holdable_component
	
func get_food_freshness():
	if tags.has(Tags.FRESH): return Tags.FRESH
	elif tags.has(Tags.STALE): return Tags.STALE
	elif tags.has(Tags.SPOILED): return Tags.SPOILED
	
func set_stored_in(station_type: GameEnums.StationType):
	stored_in = station_type
