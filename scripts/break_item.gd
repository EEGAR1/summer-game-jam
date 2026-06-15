class_name BreakItem extends PlayerItem

@onready var area_2d: Area2D = $Area2D
var ovrlp : Array :
	get():
		return area_2d.get_overlapping_areas().filter(func(x): return x is Building)

func _check_active(delta : float) -> bool:
	return len(ovrlp) > 0

func _while_active(delta : float) -> void:
	if Input.is_action_just_pressed("break"):
		var target = ovrlp[0] as Building
		target.current_state = Building.STATE.DAMAGED
		use()
