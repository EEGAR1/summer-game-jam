extends Building


func _process(delta: float) -> void:
	building_process(delta)
	
const EXPLOSION = preload("uid://b0u67intsldg8")
func damaged_process(_delta : float) -> void:
	var e = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(e)
	e.damage_type = Explosion.DAMAGE_TYPE.PEOPLE
	e.global_position = global_position
	queue_free.call_deferred()
