extends Action

@export var freq := 12

func _check_action(delta : float) -> void:
	if randi_range(0, int(freq/(delta * (parent.stress * 2.0 + 1)))) == 0:
		var amp = 250/((parent.stress/4)+1)
		parent.set_movement_target(parent.global_position + Vector2(randf_range(-amp,amp), randf_range(-amp,amp)))
