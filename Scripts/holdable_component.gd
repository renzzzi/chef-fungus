extends Node2D

@onready var interact_component = $"../InteractComponent"
@onready var parent_item: Node2D = get_parent()
var is_held = false
static var player: CharacterBody2D

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	player = get_tree().current_scene.get_node("Player")

func _process(delta: float) -> void:
	if is_held:
		parent_item.global_position = parent_item.global_position.lerp(
			Vector2(player.global_position.x, player.global_position.y - 10),
			delta * 23.0
		)

func interacted(_player):
	player.set_current_item_held(parent_item)
	is_held = true
	parent_item.z_index = 20
	
func drop():
	is_held = false
	parent_item.z_index = 5
	var tween = create_tween()
	tween.tween_property(parent_item, "global_position", 
		Vector2(player.global_position.x, player.global_position.y + 2.5), 0.16
	)

func store_in_station(station_type: GameEnums.StationType):
	interact_component.monitoring = false
	interact_component.monitorable = false
	is_held = false
	parent_item.visible = false
	parent_item.global_position = Vector2.ZERO
	parent_item.set_stored_in(station_type)
	
func unstore_from_station(station_from: Node2D):
	interact_component.monitoring = true
	interact_component.monitorable = true
	parent_item.global_position = station_from.global_position
	is_held = true
	parent_item.visible = true
	parent_item.set_stored_in(GameEnums.StationType.NONE)

func place_on_counter_top(counter_top: Node2D):
	interact_component.monitoring = false
	interact_component.monitorable = false
	is_held = false
	
	
	var final_scale = Vector2(0.7, 0.7)
	var final_pos = Vector2(counter_top.global_position.x, counter_top.global_position.y)
	var randomPos = randf_range(-1.5, 1.5)
	if parent_item is Food:
		final_scale = Vector2(0.5, 0.5)
		final_pos.x += randomPos
		final_pos.y += randomPos
	
	var tween = create_tween()
	tween.parallel().tween_property(parent_item, "global_position", final_pos, 0.16)
	tween.parallel().tween_property(parent_item, "scale", final_scale, 0.16)
	if parent_item is Food:
		parent_item.set_stored_in(GameEnums.StationType.COUNTERTOP)

func take_from_counter_top():
	interact_component.monitoring = true
	interact_component.monitorable = true
	
	var final_scale = Vector2(1.0, 1.0)
	if parent_item is Food:
		final_scale = Vector2(0.8, 0.8)
	
	var tween = create_tween()
	tween.tween_property(parent_item, "scale", final_scale, 0.16)
	is_held = true
	if parent_item is Food:
		parent_item.set_stored_in(GameEnums.StationType.NONE)
	elif parent_item is HoldableStation:
		parent_item.set_counter_top(null)
