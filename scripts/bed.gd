extends Building

@onready var idle_poi: IdlePOI = $IdlePOI

func _process(delta: float) -> void:
	building_process(delta)
	
	idle_poi.enabled = current_state == Building.STATE.BUILT
