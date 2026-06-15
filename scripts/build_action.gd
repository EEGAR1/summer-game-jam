extends Action

@onready var build_area: Area2D = $BuildArea

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var build_speed := 1.0

var overlp : Array[Area2D] : 
	get():
		return build_area.get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))

func _parent_is_ready() -> bool:
	return parent.current_state == Person.STATE.WORKING

func _check_action(delta : float):
	animation_player.play("RESET")
	
	#remove_action()
	if len(parent.current_path.path) != 0:
		build_area.global_position = parent.current_path.path.back()
	else:
		for i in overlp:
			i = i as Building
			if parent.can_command or parent.possessed: set_action()

func _while_acting(delta : float):
	animation_player.play("buildingLeft" if parent.icon.flip_h else "buildingRight")
	
	if overlp == []:	remove_action()
	
	for i in overlp:
		i = i as Building
		if i.current_state == Building.STATE.BUILDING:
			parent.stopped = true
			i.current_work += delta * build_speed
		else:
			animation_player.play("RESET")
			parent.stopped = false
			parent.current_state = Person.STATE.WORKING
			remove_action()

func _no_action(delta : float) -> void:
	animation_player.play("RESET")
