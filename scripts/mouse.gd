extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	var overlp = get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))
	if overlp != [] and overlp != null:	Globals.hover_target = overlp.back()
	else:	Globals.hover_target = null
