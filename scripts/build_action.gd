extends Action

@onready var build_area: Area2D = $BuildArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var overlp = build_area.get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))
	
	if parent_is_ready:
		print(build_area.get_overlapping_areas())
		for i in overlp:
			i = i as Building
			
			parent.current_state = Person.STATE.USINGACTION
			current_action = self
			
			i.built.connect(end)
	
	elif is_current_action:
		for i in overlp:
			i.current_work += delta

func end():
	parent.current_state = Person.STATE.WORKING
