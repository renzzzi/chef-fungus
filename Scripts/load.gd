extends Node

var load_color = {
	Food.Freshness.FRESH: Color.WHITE,
	Food.Freshness.STALE: Color(0.636, 0.321, 0.126, 1.0),
	Food.Freshness.SPOILED: Color(0.205, 0.205, 0.205, 1.0),
	
	# is_dirty (Tool)
	true: Color(0.636, 0.321, 0.126, 1.0),
	false: Color.WHITE
}

var load_entity_texture = {
	null: preload("res://Sprites/unknown.png"),
	
	# Tool
	Constants.TAMPER: preload("res://Sprites/Tools/tamper.png"),
	Constants.KNIFE: preload("res://Sprites/Tools/knife.png"),
	Constants.SHEET_PAN: preload("res://Sprites/Tools/sheet_pan.png"),
	Constants.COOKING_POT: preload("res://Sprites/Tools/cooking_pot.png"),
	Constants.FRYING_BASKET: preload("res://Sprites/Tools/frying_basket.png"),
	Constants.WOODEN_SPOON: preload("res://Sprites/Tools/wooden_spoon.png"),
	Constants.SPONGE: preload("res://Sprites/Tools/sponge.png"),
	
	# HoldableStation
	Constants.BLENDER: preload("res://Sprites/Stations/blender.png"),
	Constants.CHOPPING_BOARD: preload("res://Sprites/Stations/chopping_board.png"),
	Constants.OVEN: preload("res://Sprites/Stations/oven.png"),
	Constants.STOVE: preload("res://Sprites/Stations/stove.png"),
	Constants.DEEP_FRYER: preload("res://Sprites/Stations/deep_fryer.png"),
	Constants.MIXING_BOWL: preload("res://Sprites/Stations/mixing_bowl.png"),
	Constants.TABLET: preload("res://Sprites/Stations/tablet.png"),
	
	# Food
	Constants.SLUDGE: preload("res://Sprites/Food/sludge.png"),
	Constants.APPLE: preload("res://Sprites/Food/apple.png"),
	Constants.ORANGE: preload("res://Sprites/Food/orange.png"),
	Constants.BREAD: preload("res://Sprites/Food/bread.png"),
	Constants.DOUGH: preload("res://Sprites/Food/dough.png"),
	Constants.WATER: preload("res://Sprites/Food/water.png"),
	Constants.FLOUR: preload("res://Sprites/Food/flour.png"),
	Constants.BLENDED_APPLE: preload("res://Sprites/Food/Blended/blended_apple.png")
}

var load_entity_scene = {
	Constants.SLUDGE: preload("res://Scenes/Food/sludge.tscn"),
	
	# BASIC TIER
	Constants.ORANGE: preload("res://Scenes/Food/orange.tscn"),
	
	# PREPARED TIER
	Constants.DOUGH: preload("res://Scenes/Food/dough.tscn"),
	Constants.BREAD: preload("res://Scenes/Food/bread.tscn")
	
	# FINAL TIER
}
