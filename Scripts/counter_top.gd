extends StaticBody2D

@onready var interact_component = $InteractComponent
var placed_item = null

func _ready() -> void:
	interact_component.interacted.connect(interacted)

func interacted(player):
	if placed_item is HoldableStation:
		placed_item.get_station_ui_interact_component().interacted(null)
	elif placed_item is not Station:
		# Player holding NO food; counter top IS storing food
		if player.get_current_item_held() == null and placed_item != null:
			player.set_current_item_held(placed_item)
			placed_item = null
			player.get_current_item_held().get_holdable_component().take_from_counter_top()
		# Player IS holding food; counter top is NOT storing food
		elif player.get_current_item_held() != null and placed_item == null:
			placed_item = player.get_current_item_held()
			player.set_current_item_held(null)
			placed_item.get_holdable_component().place_on_counter_top(self)
			if placed_item is HoldableStation:
				placed_item.set_counter_top(self)
		# Player IS holding food; slot IS storing food
		elif player.get_current_item_held() != null and placed_item != null:
			var temp = player.get_current_item_held()
			player.set_current_item_held(placed_item)
			placed_item = temp
			player.get_current_item_held().get_holdable_component().take_from_counter_top()
			placed_item.get_holdable_component().place_on_counter_top(self)
			if placed_item is HoldableStation:
				placed_item.set_counter_top(self)
			
	
func clear_placed_item():
	placed_item = null
