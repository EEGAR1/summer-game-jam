class_name CustomPath

var path : Array[Vector2]

var overall_path : Array[Vector2]

func translate(n : PackedVector2Array):
	for i in n:
		path.append(i)
	overall_path = path.duplicate()

func clear():
	path.clear()

func set_link(index : int, value : Vector2):
	path.set(index, value)

func get_path() -> Array[Vector2]:
	return path

func get_link(index : int) -> Vector2:
	return path[index]

func add_link(index : int, pos : Vector2):
	path.insert(index, pos)

func get_next_pos(global_position : Vector2, velocity : Vector2) -> Vector2:
	if len(path) <= 0:	return global_position
	
	var p = path[0]
	if global_position.distance_to(p) < 8.0:
		reach()
	
	return p

func reach():
	path.pop_front()
