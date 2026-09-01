extends CharacterBody2D


const SPEED: float = 80.0
@onready var sprite2d = $Sprite2D

func _process(delta: float) -> void:
	if velocity.x >= 0.1:
		sprite2d.flip_h = false
	elif velocity.x <= -0.1:
		sprite2d.flip_h = true

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	
	velocity = direction * SPEED

	move_and_slide()
