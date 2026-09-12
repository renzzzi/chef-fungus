class_name InteractComponent
extends Area2D

signal interacted(player: CharacterBody2D)
@export var is_stationary_station: bool

func get_is_stationary_station():
	return is_stationary_station

func _on_body_entered(player: Node2D) -> void:
	if player is CharacterBody2D:
		player.register_interact_component(self)

func _on_body_exited(player: Node2D) -> void:
	if player is CharacterBody2D:
		player.unregister_interact_component(self)

func interact(player: CharacterBody2D):
	interacted.emit(player)
