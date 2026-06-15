class_name BreakAction extends Action

@onready var build_area: Area2D = $BuildArea

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var can_break := false

var overlp : Array[Area2D] : 
	get():
		return build_area.get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))

func _parent_is_ready() -> bool:
	return parent.current_state == Person.STATE.WORKING

func _check_action(delta : float):
	animation_player.play("RESET")
	
	if len(parent.current_path.path) != 0:
		build_area.global_position = parent.current_path.path.back()
	else:
		for i in overlp:
			i = i as Building
			if parent.possessed and can_break: 
				set_action()

func _while_acting(delta : float):
	animation_player.play("destroy_left" if parent.icon.flip_h else "destroy_right")
	
	if overlp == []:	
		can_break = false
		remove_action()
	
	for i in overlp:
		i = i as Building
		if i.current_state == Building.STATE.BUILT:
			parent.stopped = true
			i.current_state = Building.STATE.DAMAGED
			can_break = false
			remove_action()

func _no_action(delta : float) -> void:
	animation_player.play("RESET")
