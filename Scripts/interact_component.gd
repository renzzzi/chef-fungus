class_name InteractComponent
extends Area2D

signal interacted(player: CharacterBody2D)

func _on_body_entered(player: Node2D) -> void:
	if player is CharacterBody2D:
		player.register_interact_component(self)

func _on_body_exited(player: Node2D) -> void:
	if player is CharacterBody2D:
		player.unregister_interact_component(self)

func interact(player: CharacterBody2D):
	interacted.emit(player)
