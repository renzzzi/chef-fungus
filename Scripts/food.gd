class_name Food
extends Node2D

@onready var interact_component = $InteractComponent
@export var food_type: GameEnums.FoodType

static var player: CharacterBody2D
var is_held = false

func get_food_type():
	return food_type

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

func store():
	interact_component.monitoring = false
	interact_component.monitorable = false
	is_held = false
	visible = false
	global_position = Vector2.ZERO
	
func unstore(station_from: Node2D):
	interact_component.monitoring = true
	interact_component.monitorable = true
	global_position = station_from.global_position
	visible = true
	is_held = true

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

func take_from_counter_top():
	interact_component.monitoring = true
	interact_component.monitorable = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.16)
	is_held = true
