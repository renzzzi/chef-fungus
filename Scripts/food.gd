class_name Food
extends Node2D

@onready var interact_component = $InteractComponent
@export var food_type: GameEnums.FoodType

static var player: CharacterBody2D
var is_held = false
var stored_in := GameEnums.StationType.NONE

# How long it takes in second before food changes freshness
var food_freshness := GameEnums.FoodFreshness.FRESH
var expiry_counter: float = 0.0
@export var STALE: int
@export var EXPIRED: int

func _on_timer_timeout() -> void:
	# Slows down expiry based on where food is stored in
	match stored_in:
		GameEnums.StationType.FRIDGE:
			expiry_counter += 0
		GameEnums.StationType.COUNTERTOP, GameEnums.StationType.STOVE, GameEnums.StationType.BLENDER:
			expiry_counter += 0.75
			
	if stored_in == GameEnums.StationType.FRIDGE:
		expiry_counter += 0
	elif stored_in == GameEnums.StationType.COUNTERTOP:
		expiry_counter += 0.75
	else:
		expiry_counter += 1
	
	# Changed food_freshness and tint
	if expiry_counter >= STALE and expiry_counter < EXPIRED:
		food_freshness = GameEnums.FoodFreshness.STALE
		modulate = GameEnums.load_color[food_freshness]
	elif expiry_counter >= EXPIRED:
		food_freshness = GameEnums.FoodFreshness.EXPIRED
		modulate = GameEnums.load_color[food_freshness]
	
func get_food_type():
	return food_type
	
func get_food_freshness():
	return food_freshness

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	player = get_tree().current_scene.get_node("Player")

func _process(delta: float) -> void:
	if is_held:
		global_position = global_position.lerp(
			Vector2(player.global_position.x, player.global_position.y - 10),
			delta * 23.0
		)

func interacted(_player):
	player.set_current_food_held(self)
	is_held = true
	self.z_index = 20
	
func drop():
	is_held = false
	self.z_index = 5
	var tween = create_tween()
	tween.tween_property(self, "global_position", 
		Vector2(player.global_position.x, player.global_position.y + 2.5), 0.16
	)

func store_in_station(station_type: GameEnums.StationType):
	interact_component.monitoring = false
	interact_component.monitorable = false
	is_held = false
	visible = false
	global_position = Vector2.ZERO
	stored_in = station_type
	
func unstore_from_station(station_from: Node2D):
	interact_component.monitoring = true
	interact_component.monitorable = true
	global_position = station_from.global_position
	visible = true
	is_held = true
	stored_in = GameEnums.StationType.NONE

func place_on_counter_top(counter_top: Node2D):
	interact_component.monitoring = false
	interact_component.monitorable = false
	is_held = false
	
	var tween = create_tween()
	var randomPos = randf_range(-1.5, 1.5)
	tween.parallel().tween_property(self, "global_position", 
		Vector2(counter_top.global_position.x + randomPos, counter_top.global_position.y + randomPos), 
		0.16
	)
	tween.parallel().tween_property(self, "scale", Vector2(0.5, 0.5), 0.16)
	stored_in = GameEnums.StationType.COUNTERTOP

func take_from_counter_top():
	interact_component.monitoring = true
	interact_component.monitorable = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.16)
	is_held = true
	stored_in = GameEnums.StationType.NONE
