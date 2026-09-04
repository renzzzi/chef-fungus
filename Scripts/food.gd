class_name Food
extends Node2D

@onready var interact_component = $InteractComponent
@export var food_type: GameEnums.FoodType

static var player: CharacterBody2D
var is_held = false
var is_dropping = false

func _ready() -> void:
	interact_component.interacted.connect(interacted)
	player = get_tree().current_scene.get_node("Player")

func _process(delta: float) -> void:
	if is_held:
		global_position = global_position.lerp(
			Vector2(player.global_position.x, player.global_position.y - 10),
			delta * 23.0
		)

func interacted(player):
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
