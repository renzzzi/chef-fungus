class_name Food
extends Node2D

var stored_in := ""
@onready var holdable_component = $HoldableComponent
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
	PLAIN, SALTED, SPICY, SWEET, HERBED, BITTER, SOUR, CREAMY
}

enum Classification {
	VEGETABLE, # Carrot, Onion, Lettuce, Mushroom
	FRUIT,     # Apple, Berry, Banana, Lemon
	MEAT,      # Beef, Pork, Chicken
	SEAFOOD,   # Fish, Shrimp, Crab
	DAIRY,     # Milk, Cheese, Butter
	EGG,       # Chicken Egg, Duck Egg, Quail Egg
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

func _on_timer_timeout() -> void:
	# Slows down expiry based on where food is stored in
	match stored_in:
		"Fridge":
			expiry_counter += 0.1
		"Oven", "Blender":
			expiry_counter += 0.6
		"CounterTop", "Stove", "MixingBowl", "DeepFryer", "ChoppingBoard":
			expiry_counter += 0.75
		"TrashCan":
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
	
