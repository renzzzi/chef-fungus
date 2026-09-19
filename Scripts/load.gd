extends Node

var load_tool_texture = {
	null: preload("res://Sprites/unknown.png"),
	Constants.TAMPER: preload("res://Sprites/Tools/tamper.png"),
	Constants.KNIFE: preload("res://Sprites/Tools/knife.png"),
	Constants.SHEET_PAN: preload("res://Sprites/Tools/sheet_pan.png"),
	Constants.COOKING_POT: preload("res://Sprites/Tools/cooking_pot.png"),
	Constants.FRYING_BASKET: preload("res://Sprites/Tools/frying_basket.png"),
	Constants.WOODEN_SPOON: preload("res://Sprites/Tools/wooden_spoon.png"),
	Constants.SPONGE: preload("res://Sprites/Tools/sponge.png")
}

var load_holdable_station_texture = {
	null: preload("res://Sprites/unknown.png"),
	Constants.BLENDER: preload("res://Sprites/Stations/blender.png"),
	Constants.CHOPPING_BOARD: preload("res://Sprites/Stations/chopping_board.png"),
	Constants.OVEN: preload("res://Sprites/Stations/oven.png"),
	Constants.STOVE: preload("res://Sprites/Stations/stove.png"),
	Constants.DEEP_FRYER: preload("res://Sprites/Stations/deep_fryer.png"),
	Constants.MIXING_BOWL: preload("res://Sprites/Stations/mixing_bowl.png")
}

# Used for stations with UI, refer to station_ui.gd
#var load_station_string = {
	#GameEnums.StationType.FRIDGE: "Fridge",
	#GameEnums.StationType.STOVE: "Stove",
	#GameEnums.StationType.BLENDER: "Blender",
	#GameEnums.StationType.CHOPPING_BOARD: "ChoppingBoard",
	#GameEnums.StationType.OVEN: "Oven",
	#GameEnums.StationType.DEEP_FRYER: "DeepFryer",
	#GameEnums.StationType.MIXING_BOWL: "MixingBowl"
#}

var load_color = {
	Food.Freshness.FRESH: Color.WHITE,
	Food.Freshness.STALE: Color(0.636, 0.321, 0.126, 1.0),
	Food.Freshness.SPOILED: Color(0.205, 0.205, 0.205, 1.0),
	true: Color(0.636, 0.321, 0.126, 1.0),
	false: Color.WHITE
}

var load_food_texture = {
	null: preload("res://Sprites/unknown.png"),
	Constants.SLUDGE: preload("res://Sprites/Food/sludge.png"),
	Constants.APPLE: preload("res://Sprites/Food/apple.png"),
	Constants.ORANGE: preload("res://Sprites/Food/orange.png"),
	Constants.BREAD: preload("res://Sprites/Food/bread.png"),
	Constants.DOUGH: preload("res://Sprites/Food/dough.png"),
	Constants.WATER: preload("res://Sprites/Food/water.png"),
	Constants.FLOUR: preload("res://Sprites/Food/flour.png"),
	Constants.BLENDED_APPLE: preload("res://Sprites/Food/Blended/blended_apple.png")
}

var load_food_scene = {
	Constants.SLUDGE: preload("res://Scenes/Food/sludge.tscn"),
	
	# BASIC TIER
	Constants.ORANGE: preload("res://Scenes/Food/orange.tscn"),
	
	# PREPARED TIER
	Constants.DOUGH: preload("res://Scenes/Food/dough.tscn"),
	Constants.BREAD: preload("res://Scenes/Food/bread.tscn")
	
	# FINAL TIER
}
