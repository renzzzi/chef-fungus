extends Node

var load_food_texture = {
	null: preload("res://Sprites/unknown.png"),
	"Apple": preload("res://Sprites/Food/apple.png"),
	"Orange": preload("res://Sprites/Food/orange.png"),
	"Bread": preload("res://Sprites/Food/bread.png"),
	"Dough": preload("res://Sprites/Food/dough.png"),
	"Water": preload("res://Sprites/Food/water.png"),
	"Flour": preload("res://Sprites/Food/flour.png")
}

var load_tool_texture = {
	null: preload("res://Sprites/unknown.png"),
	"Tamper": preload("res://Sprites/Tools/tamper.png"),
	"Knife": preload("res://Sprites/Tools/knife.png"),
	"SheetPan": preload("res://Sprites/Tools/sheet_pan.png"),
	"CookingPot": preload("res://Sprites/Tools/cooking_pot.png")
	#"FryingBasket": preload("res://Sprites/Tools/frying_basket.png"),
	#"WoodenSpoon": preload("res://Sprites/Tools/wooden_spoon.png"),
	#"Sponge": preload("res://Sprites/Tools/sponge.png")
}

var load_holdable_station_texture = {
	"": preload("res://Sprites/unknown.png"),
	"Blender": preload("res://Sprites/Stations/blender.png"),
	"ChoppingBoard": preload("res://Sprites/Stations/chopping_board.png"),
	"Oven": preload("res://Sprites/Stations/oven.png"),
	"Stove": preload("res://Sprites/Stations/stove.png"),
	"DeepFryer": preload("res://Sprites/Stations/deep_fryer.png"),
	"MixingBowl": preload("res://Sprites/Stations/mixing_bowl.png")
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
	Food.Freshness.SPOILED: Color(0.205, 0.205, 0.205, 1.0)
}
