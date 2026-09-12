class_name Food
extends Node2D

@export var food_type: GameEnums.FoodType
@onready var holdable_component = $HoldableComponent
var stored_in := GameEnums.StationType.NONE

# How long it takes in second before food changes freshness
var food_freshness := GameEnums.FoodFreshness.FRESH
var expiry_counter: float = 0.0
@export var STALE: int
@export var SPOILED: int

func _on_timer_timeout() -> void:
	# Slows down expiry based on where food is stored in
	match stored_in:
		GameEnums.StationType.FRIDGE:
			expiry_counter += 0
		GameEnums.StationType.COUNTERTOP, GameEnums.StationType.STOVE, GameEnums.StationType.BLENDER:
			expiry_counter += 0.75
		GameEnums.StationType.NONE:
			expiry_counter += 1
			
	if stored_in == GameEnums.StationType.FRIDGE:
		expiry_counter += 0
	elif stored_in == GameEnums.StationType.COUNTERTOP:
		expiry_counter += 0.75
	else:
		expiry_counter += 1
	
	# Changed food_freshness and tint
	if expiry_counter >= STALE and expiry_counter < SPOILED:
		food_freshness = GameEnums.FoodFreshness.STALE
		modulate = GameEnums.load_color[food_freshness]
	elif expiry_counter >= SPOILED:
		food_freshness = GameEnums.FoodFreshness.SPOILED
		modulate = GameEnums.load_color[food_freshness]

func get_food_type():
	return food_type
	
func get_food_freshness():
	return food_freshness
	
func get_holdable_component():
	return holdable_component
	
func set_stored_in(station_type: GameEnums.StationType):
	stored_in = station_type
