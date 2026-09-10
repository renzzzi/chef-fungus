extends Node

enum FoodType {
	NONE, APPLE, ORANGE
}

enum StationType {
	NONE, FRIDGE, COUNTERTOP, STOVE, BLENDER
}

var load_texture = {
	FoodType.NONE: preload("res://Sprites/unknown_food.png"),
	FoodType.APPLE: preload("res://Sprites/apple.png"),
	FoodType.ORANGE: preload("res://Sprites/orange.png"),
}
