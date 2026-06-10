class_name FOVArea2D extends Area2D

# Obv this is not a very realistic implementation but its fine for now. I dont want to code allat

func get_fov_overlapping_areas():
	var output : Array[Area2D]
	for area in get_overlapping_areas():
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.create(global_position, area.global_position)
		var result = space_state.intersect_ray(query)
		if result == {}: # Since raycasts cant collide with areas normally, if the raycast returns empty we can see the area
			output.append(area)
	
	return output

func get_fov_overlapping_bodies():
	var output : Array[Area2D]
	for body in get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.create(global_position, body.global_position)
		var result = space_state.intersect_ray(query)
		if result.collider == body:
			output.append(body)
	
	return output
