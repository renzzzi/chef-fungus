extends Node

var load_food_texture = {
	GameEnums.FoodType.NONE: preload("res://Sprites/unknown.png"),
	GameEnums.FoodType.APPLE: preload("res://Sprites/Food/apple.png"),
	GameEnums.FoodType.ORANGE: preload("res://Sprites/Food/orange.png"),
	GameEnums.FoodType.BREAD: preload("res://Sprites/Food/bread.png")
}

var load_tool_texture = {
	GameEnums.ToolType.NONE: preload("res://Sprites/unknown.png"),
	GameEnums.ToolType.TAMPER: preload("res://Sprites/Tools/tamper.png"),
	GameEnums.ToolType.KNIFE: preload("res://Sprites/Tools/knife.png"),
	GameEnums.ToolType.SHEET_PAN: preload("res://Sprites/Tools/sheet_pan.png"),
	GameEnums.ToolType.COOKING_POT: preload("res://Sprites/Tools/cooking_pot.png")
}

var load_holdable_station_texture = {
	GameEnums.StationType.NONE: preload("res://Sprites/unknown.png"),
	GameEnums.StationType.BLENDER: preload("res://Sprites/Stations/blender.png"),
	GameEnums.StationType.CHOPPING_BOARD: preload("res://Sprites/Stations/chopping_board.png"),
	GameEnums.StationType.OVEN: preload("res://Sprites/Stations/oven.png"),
	GameEnums.StationType.STOVE: preload("res://Sprites/Stations/stove.png"),
	GameEnums.StationType.DEEP_FRYER: preload("res://Sprites/Stations/deep_fryer.png"),
	GameEnums.StationType.MIXING_BOWL: preload("res://Sprites/Stations/mixing_bowl.png"),
}

# Used for stations with UI, refer to station_ui.gd
var load_station_string = {
	GameEnums.StationType.FRIDGE: "Fridge",
	GameEnums.StationType.STOVE: "Stove",
	GameEnums.StationType.BLENDER: "Blender",
	GameEnums.StationType.CHOPPING_BOARD: "ChoppingBoard",
	GameEnums.StationType.OVEN: "Oven",
	GameEnums.StationType.DEEP_FRYER: "DeepFryer",
	GameEnums.StationType.MIXING_BOWL: "MixingBowl"
}

var load_color = {
	Tags.FRESH: Color.WHITE,
	Tags.STALE: Color(0.636, 0.321, 0.126, 1.0),
	Tags.SPOILED: Color(0.205, 0.205, 0.205, 1.0)
}
