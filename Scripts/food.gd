class_name Food
extends Node2D

var stored_in := ""
@onready var holdable_component = $HoldableComponent
@onready var sprite_2d = $Sprite2D

## Food name must be in PascalCase with a space after each word (e.g. "Boiled Egg")
@export var food_name: String
# How long it takes in second before food changes freshness
var expiry_counter: float = 0.0
@export var STALETIME: int
@export var SPOILEDTIME: int

# --- ENUMS ---
enum Shape { WHOLE, BLENDED, CHOPPED }
enum Cook { RAW, BOILED, BAKED, FRIED }
enum Tier { BASIC, PREPARED, FINAL }
enum Freshness { FRESH, STALE, SPOILED }

enum Flavor { 
	PLAIN, SALTED, SPICY, SWEET, AROMATIC, BITTER, SOUR, CREAMY
}

enum Classification {
	VEGETABLE, # Carrot, Onion, Lettuce, Mushroom
	FRUIT,     # Apple, Berry, Banana, Lemon
	MEAT,      # Beef, Pork, Chicken
	SEAFOOD,   # Fish, Shrimp, Crab
	DAIRY,     # Milk, Cheese, Butter
	EGG,       # Chicken Egg, Duck Eggfunc blend():
	CARB,      # Bread, Potato, Rice, Pasta, Flour
	FLAVORING, # Salt, Pepper, Sugar, Spices, Herbs
	LIQUID     # Water, Broth, Cooking Oil
}

# --- PROPERTIES (Show as Dropdowns in Inspector) ---

@export_group("What Has Been Done to The Food")
@export var shape_state: Shape = Shape.WHOLE
@export var cook_state: Cook = Cook.RAW
@export var flavor_state: Array[Flavor]

@export_group("Nature of the Food")
@export var tier: Tier = Tier.BASIC
@export var freshness: Freshness = Freshness.FRESH
# Classification as an Array so an item can be Meat AND Dairy if needed
@export var classifications: Array[Classification]

func boil():
	if cook_state != Cook.RAW:
		push_error("Cannot boil " + food_name + " since it has already been cooked before.")
		return
	
	cook_state = Cook.BOILED
	tier = Tier.PREPARED
	food_name = "Boiled " + food_name
	
	# Rolls back freshness by one state
	if freshness == Freshness.STALE:
		freshness = Freshness.FRESH
		expiry_counter = 0.0
	elif freshness == Freshness.SPOILED:
		freshness = Freshness.STALE
		expiry_counter = STALETIME
	
func bake():
	if cook_state != Cook.RAW:
		push_error("Cannot bake " + food_name + " since it has already been cooked before.")
		return
		
	cook_state = Cook.BAKED
	tier = Tier.PREPARED
	food_name = "Baked " + food_name
	
	# Rolls back freshness by one state
	if freshness == Freshness.STALE:
		freshness = Freshness.FRESH
		expiry_counter = 0.0
	elif freshness == Freshness.SPOILED:
		freshness = Freshness.STALE
		expiry_counter = STALETIME
	
func fry():
	if cook_state != Cook.RAW:
		push_error("Cannot fry " + food_name + " since it has already been cooked before.")
		return
		
	cook_state = Cook.FRIED
	tier = Tier.PREPARED
	food_name = "Fried " + food_name
	
	# Rolls back freshness by one state
	if freshness == Freshness.STALE:
		freshness = Freshness.FRESH
		expiry_counter = 0.0
	elif freshness == Freshness.SPOILED:
		freshness = Freshness.STALE
		expiry_counter = STALETIME
	
func blend():
	if shape_state != Shape.WHOLE:
		push_error("Cannot blend " + food_name + " since it was either chopped or blended already.")
		return
		
	# This whole block formats the food name from this "Blended Apple" to this "blended_apple"
	var formatted_food_name = ""
	var lowercase = true
	for letter in food_name:
		if lowercase:
			formatted_food_name += letter.to_lower()
			lowercase = false
		else:
			formatted_food_name += letter
			
		if letter == " ":
			formatted_food_name += "_"
			lowercase = true
			
	# Only accepts .png sprites
	var blended_texture: Texture2D = load("res://Sprites/Food/Blended/blended_" + formatted_food_name + ".png")
	sprite_2d.texture = blended_texture
	shape_state = Shape.BLENDED
	tier = Tier.PREPARED
	food_name = "Blended " + food_name
	
func chop():
	if shape_state != Shape.WHOLE:
		push_error("Cannot chop " + food_name + " since it was either chopped or blended already.")
		return
		
	# This whole block formats the food name from this "Chopped Apple" to this "chopped_apple"
	var formatted_food_name
	var lowercase = true
	for letter in food_name:
		if lowercase:
			formatted_food_name += letter.to_lower()
			lowercase = false
		else:
			formatted_food_name += letter
			
		if letter == " ":
			formatted_food_name += "_"
			lowercase = true
			
	# Only accepts .png sprites
	var chopped_texture: Texture2D = load("res://Sprites/Food/Chopped/chopped_" + formatted_food_name + ".png")
	sprite_2d.texture = chopped_texture
	shape_state = Shape.CHOPPED
	tier = Tier.PREPARED
	food_name = "Chopped " + food_name

func _on_timer_timeout() -> void:
	# Slows down expiry based on where food is stored in
	match stored_in:
		Constants.FRIDGE:
			expiry_counter += 0.1
		Constants.OVEN, Constants.BLENDER:
			expiry_counter += 0.6
		Constants.COUNTERTOP, Constants.STOVE, Constants.MIXING_BOWL, Constants.DEEP_FRYER, Constants.CHOPPING_BOARD:
			expiry_counter += 0.75
		Constants.TRASH_CAN:
			expiry_counter += 9999
		_:
			expiry_counter += 1
	
	# Changed food_freshness and tint
	if expiry_counter >= STALETIME and expiry_counter < SPOILEDTIME:
		if freshness != Freshness.STALE:
			freshness = Freshness.STALE
			modulate = Load.load_color[freshness]
	elif expiry_counter >= SPOILEDTIME:
		if freshness != Freshness.SPOILED:
			freshness = Freshness.SPOILED
			modulate = Load.load_color[freshness]
	
func get_food_name():
	return food_name
	
func get_shape_state():
	return shape_state
	
func get_cook_state():
	return cook_state
	
func get_flavor_state():
	return flavor_state
	
func get_tier():
	return tier

func get_food_freshness():
	return freshness
	
func get_classifications() -> Array[Classification]:
	return classifications

func get_holdable_component():
	return holdable_component
	
func set_stored_in(station_type: String):
	stored_in = station_type
	
