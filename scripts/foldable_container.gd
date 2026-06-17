extends FoldableContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(get_tree().current_scene):	
		visible = len(get_tree().current_scene.get_children().filter(func(x): return x is Building).filter(func(x): return x.current_state == Building.STATE.PLACING)) == 0
