extends TileMapLayer

var _obstacles: Array[TileMapLayer] = []

func _ready() -> void:
	_get_obstacle_layers()

func _get_obstacle_layers():
	# make sure the name here is the same as the group's
	var layers = get_tree().get_nodes_in_group("Obs")

	for layer in layers:
		if layer is not TileMapLayer: continue
		_obstacles.append(layer)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return _is_used_by_obstacle(coords)

func _is_used_by_obstacle(coords: Vector2i) -> bool:
	for layer in _obstacles:
		if coords in layer.get_used_cells():
			var tile_data = layer.get_cell_tile_data(coords)
			if tile_data.get_collision_polygons_count(0) > 0:
				return true
	return false
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if _is_used_by_obstacle(coords):
		tile_data.set_navigation_polygon(0, null)
		
	navigation_enabled = false
	await get_tree().process_frame
	navigation_enabled = true
