extends Action

@onready var build_area: Area2D = $BuildArea

var overlp : Array[Area2D] : 
	get():
		return build_area.get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))
		
func _check_action(delta : float):
	for i in overlp:
		i = i as Building
		set_action()
		i.built.connect(end)

func _while_acting(delta : float):
	for i in overlp:
		i.current_work += delta

func end():
	parent.current_state = Person.STATE.WORKING
