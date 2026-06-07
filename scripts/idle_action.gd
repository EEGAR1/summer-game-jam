extends Action

@export var freq := 24

func _check_action(delta : float) -> void:
	var rand = randi_range(0, int(freq/(delta * (parent.stress * 2.0 + 1))))
	if rand == 0:
		var amp = 250/((parent.stress/4)+1)
		parent.set_movement_target(parent.global_position + Vector2(randf_range(-amp,amp), randf_range(-amp,amp)))
	elif rand == 1 and Globals.idle_pois != []:
		parent.set_movement_target(Globals.idle_pois.pick_random().global_position)
