extends CharacterBody2D


const SPEED: float = 80.0
@onready var sprite_2d = $Sprite2D
var current_food_held = null
var nearby_interact_components: Array[InteractComponent] = []
# Stores the interact components that were recently interacted with by the player
var recent_interact_components: Array[InteractComponent] = []
@onready var fridge = get_tree().current_scene.get_node("Fridge")
@onready var stove = get_tree().current_scene.get_node("Stove")

func _ready() -> void:
	fridge.station_interacted.connect(station_interacted)
	stove.station_interacted.connect(station_interacted)

func set_current_food_held(new_food):
	current_food_held = new_food

func get_current_food_held():
	return current_food_held

func register_interact_component(interact_component):
	if !nearby_interact_components.has(interact_component):
		nearby_interact_components.append(interact_component)
		
func unregister_interact_component(interact_component):
	if nearby_interact_components.has(interact_component):
		nearby_interact_components.erase(interact_component)
	if recent_interact_components.has(interact_component):
		# Removed the interact component in this array if player went out of range
		recent_interact_components.erase(interact_component)
		
func station_interacted(ui_active):
	# If ui_active is true then disable player physics and vice-versa
	set_physics_process(!ui_active)
	
func _process(_delta: float) -> void:
	if velocity.x < -0.1:
		sprite_2d.flip_h = true
	elif velocity.x > 0.1:
		sprite_2d.flip_h = false

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if nearby_interact_components.is_empty():
			return
		
		# Checks for nearby stations first and interacts with them
		for component in nearby_interact_components:
			if component.get_is_station():
				component.interact(self)
				return
		
		if nearby_interact_components == recent_interact_components:
			recent_interact_components.clear()
		
		if current_food_held:
			current_food_held.drop()
			current_food_held = null
		else:
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
