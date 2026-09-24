extends CharacterBody2D


const SPEED: float = 80.0
@onready var sprite_2d = $Sprite2D
var nearby_interact_components: Array[InteractComponent] = []
# Stores the interact components that were recently interacted with by the player
var recent_interact_components: Array[InteractComponent] = []
var last_interacted_station_ui: InteractComponent
var in_station_interface = false

signal held_item_updated

var current_item_held = null:
	set(value):
		# Stop listening to the old item
		if current_item_held is Food and current_item_held.freshness_changed.is_connected(_on_held_food_freshness_changed):
			current_item_held.freshness_changed.disconnect(_on_held_food_freshness_changed)
		
		current_item_held = value
		
		# Start listening to the new one
		if current_item_held is Food:
			current_item_held.freshness_changed.connect(_on_held_food_freshness_changed)
		
		held_item_updated.emit()

func _on_held_food_freshness_changed(_food: Food, _new_freshness: Food.Freshness) -> void:
	held_item_updated.emit()

func _ready() -> void:
	for station in get_tree().get_nodes_in_group("station"):
		station.station_ui_interact_component.station_interacted.connect(station_interacted)

func register_interact_component(interact_component):
	if !nearby_interact_components.has(interact_component):
		nearby_interact_components.append(interact_component)
		
func unregister_interact_component(interact_component):
	if nearby_interact_components.has(interact_component):
		nearby_interact_components.erase(interact_component)
	if recent_interact_components.has(interact_component):
		# Removed the interact component in this array if player went out of range
		recent_interact_components.erase(interact_component)
		
func station_interacted(_station, ui_active):
	# If ui_active is true then disable player physics and vice-versa
	set_physics_process(!ui_active)
	in_station_interface = ui_active
	if !ui_active:
		last_interacted_station_ui = null
	
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
		if last_interacted_station_ui != null:
			last_interacted_station_ui.interact(self)
			last_interacted_station_ui = null
			return
		
		if nearby_interact_components.is_empty():
			return
	
		# Checks for nearby stations first and interacts with them
		for component in nearby_interact_components:
			if component.is_stationary_station:
				component.interact(self)
				if in_station_interface:
					last_interacted_station_ui = component
				return
	
		if nearby_interact_components == recent_interact_components:
			recent_interact_components.clear()
		
		if current_item_held:
			current_item_held.holdable_component.drop()
			current_item_held = null
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
