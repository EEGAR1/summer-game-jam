extends PlayerItem

var tooltip : Control
func _ready() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	tooltip = Globals.tooltip
	tooltip.hide()

var ovrlp : Array : 
	get(): 
		return Globals.mouse.get_overlapping_bodies().filter(func(x): return x is Person)

func _check_active(delta : float) -> bool:
	return true

var window_open := false
var label_showing := false
var target : Person
var paused := false

func _always(delta : float) -> void:
	pass

func _while_active(delta : float) -> void:
	if Input.is_action_pressed("peek") and len(ovrlp) != 0:
		tooltip.visible = true
		tooltip.text = str((ovrlp[0] as Person).emotion_manager.emotions)
	if Input.is_action_just_released("peek"):
		tooltip.hide()
		use()
