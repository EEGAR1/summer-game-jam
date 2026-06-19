class_name IdleAction extends Action

@export var freq := 12

func _check_action(delta : float) -> void:
	var rand = randi_range(0, int(freq/(delta * (parent.stress * 1.5 + 1))))
	if rand == 0:
		set_action()

func _while_acting(delta : float) -> void:
	parent.current_state = parent.STATE.WORKING
	if randi_range(0,1) == 0:
		var amp = 250/((parent.stress/5)+1)
		parent.set_movement_target(parent.global_position + Vector2(randf_range(-amp,amp), randf_range(-amp,amp)))
	else:
		parent.set_movement_target(Globals.idle_pois.pick_random().global_position)
	
	remove_action()
