extends Action

@export var freq := 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent_is_ready:
		if randi_range(0, int(freq/(delta * (parent.stress + 1)))) == 0:
			parent.set_movement_target(parent.global_position + Vector2(randf_range(-250,250), randf_range(-250,250)))
