extends Node

enum FoodType {
	NONE, APPLE, ORANGE, BREAD
}

enum FoodStates {
	NONE, WHOLE, CHOPPED, BOILED, BLENDED, BAKED
}

enum FoodCategory {
	NONE, MEAT, FISH, CARB, VEGETABLE, FRUIT
}

enum FoodFreshness {
	NONE, FRESH, STALE, SPOILED
}

enum StationType {
	NONE, FRIDGE, COUNTERTOP, STOVE, BLENDER, CHOPPING_BOARD, OVEN
}

enum ToolType {
	NONE, TAMPER, KNIFE, SHEET_PAN, COOKING_POT
}

var load_texture = {
	FoodType.NONE: preload("res://Sprites/Food/unknown_food.png"),
	FoodType.APPLE: preload("res://Sprites/Food/apple.png"),
	FoodType.ORANGE: preload("res://Sprites/Food/orange.png"),
	FoodType.BREAD: preload("res://Sprites/Food/bread.png")
}

var load_color = {
	FoodFreshness.NONE: Color.WHITE,
	FoodFreshness.FRESH: Color.WHITE,
	FoodFreshness.STALE: Color(0.636, 0.321, 0.126, 1.0),
	FoodFreshness.SPOILED: Color(0.205, 0.205, 0.205, 1.0)
}

# Used for stations with UI, refer to station_ui.gd
var load_station_string = {
	StationType.FRIDGE: "Fridge",
	StationType.STOVE: "Stove",
	StationType.BLENDER: "Blender"
}
