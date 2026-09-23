extends Control

func _ready() -> void:
	for station in get_tree().get_nodes_in_group("station"):
		station.station_ui_interact_component.station_interacted.connect(toggle_ui)

func toggle_ui(station: Station, ui_active: bool):
	for child in self.get_children():
		if child.station_name == station.station_name and ui_active:
			child.station_interacted(ui_active)
			if ui_active:
				child.bind_station(station)
			else:
				child.unbind_station(station)
