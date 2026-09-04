extends CharacterBody2D


const SPEED: float = 80.0
@onready var sprite_2d = $Sprite2D
var current_food_held = null
var nearby_interact_components: Array[InteractComponent] = []
# Stores the interact components that were recently interacted with by the player
var recent_interact_components: Array[InteractComponent] = []

func set_current_food_held(new_food):
	current_food_held = new_food

func register_interact_component(interact_component):
	if !nearby_interact_components.has(interact_component):
		nearby_interact_components.append(interact_component)
	
func unregister_interact_component(interact_component):
	if nearby_interact_components.has(interact_component):
		nearby_interact_components.erase(interact_component)
	if recent_interact_components.has(interact_component):
		# Removed the interact component in this array if player went out of range
		recent_interact_components.erase(interact_component)

#func _process(delta: float) -> void:

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if current_food_held:
			current_food_held.drop()
			current_food_held = null
		elif !nearby_interact_components.is_empty():
			if nearby_interact_components == recent_interact_components:
				recent_interact_components.clear()

			# Checks if the player has recently picked up a nearby interact component
			for component in nearby_interact_components:
				if !recent_interact_components.has(component):
					component.interact(self)
					recent_interact_components.append(component)
					break
			
			nearby_interact_components.sort_custom(func(a, b):
				return a.get_instance_id() < b.get_instance_id()
			)
			recent_interact_components.sort_custom(func(a, b):
				return a.get_instance_id() < b.get_instance_id()
			)

	if event.is_action_pressed("Left"):
		sprite_2d.flip_h = true
	elif event.is_action_pressed("Right"):
		sprite_2d.flip_h = false
