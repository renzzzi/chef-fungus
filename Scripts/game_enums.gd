extends Node

enum FoodType {
	NONE, APPLE, ORANGE, BREAD
}

enum FoodFreshness {
	NONE, FRESH, STALE, EXPIRED
}

enum StationType {
	NONE, FRIDGE, COUNTERTOP, STOVE, BLENDER
}

var load_texture = {
	FoodType.NONE: preload("res://Sprites/unknown_food.png"),
	FoodType.APPLE: preload("res://Sprites/apple.png"),
	FoodType.ORANGE: preload("res://Sprites/orange.png"),
	FoodType.BREAD: preload("res://Sprites/bread.png")
}

var load_color = {
	FoodFreshness.NONE: Color.WHITE,
	FoodFreshness.FRESH: Color.WHITE,
	FoodFreshness.STALE: Color(0.636, 0.321, 0.126, 1.0),
	FoodFreshness.EXPIRED: Color(0.205, 0.205, 0.205, 1.0)
}

# Used for stations with UI, refer to station_ui.gd
var load_station_string = {
	StationType.FRIDGE: "Fridge",
	StationType.STOVE: "Stove",
	StationType.BLENDER: "Blender"
}
