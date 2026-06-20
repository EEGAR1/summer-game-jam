class_name IdleAction extends Action

@export var freq := 12

func _check_action(delta : float) -> void:
	var rand = randi_range(0, int(freq/(delta * (parent.stress * 1.5 + 1))))
	if rand == 0:
		set_action()

func _while_acting(delta : float) -> void:
	parent.current_state = parent.STATE.WORKING
	if randi_range(0,1) == 0:
		random_walk()
	else:
		var points = Globals.idle_pois.filter(func(x): return x != null).filter(func(x): return x.global_position.distance_to(parent.global_position) < 300.0 and x.global_position.distance_to(parent.global_position) > 25.0)
		if points == null:	random_walk(); return
		if len(points) == 0:	random_walk(); return
		parent.set_movement_target(points.pick_random().global_position + Vector2(randf_range(-55.0,55.0), randf_range(-55.0,55.0)))
	
	remove_action()

func random_walk():
	var amp = 250/((parent.stress/5)+1)
	parent.set_movement_target(parent.global_position + Vector2(randf_range(-amp,amp), randf_range(-amp,amp)))
	
