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

var load_food_texture = {
	FoodType.NONE: preload("res://Sprites/unknown.png"),
	FoodType.APPLE: preload("res://Sprites/Food/apple.png"),
	FoodType.ORANGE: preload("res://Sprites/Food/orange.png"),
	FoodType.BREAD: preload("res://Sprites/Food/bread.png")
}

var load_tool_texture = {
	ToolType.NONE: preload("res://Sprites/unknown.png"),
	ToolType.TAMPER: preload("res://Sprites/Tools/tamper.png"),
	ToolType.KNIFE: preload("res://Sprites/Tools/knife.png"),
	ToolType.SHEET_PAN: preload("res://Sprites/Tools/sheet_pan.png"),
	ToolType.COOKING_POT: preload("res://Sprites/Tools/cooking_pot.png")
}

var load_holdable_station_texture = {
	StationType.NONE: preload("res://Sprites/unknown.png"),
	StationType.BLENDER: preload("res://Sprites/Stations/blender.png"),
	StationType.CHOPPING_BOARD: preload("res://Sprites/Stations/chopping_board.png"),
	StationType.OVEN: preload("res://Sprites/Stations/oven.png"),
	StationType.STOVE: preload("res://Sprites/Stations/stove.png")
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
	StationType.BLENDER: "Blender",
	StationType.CHOPPING_BOARD: "ChoppingBoard",
	StationType.OVEN: "Oven"
}
