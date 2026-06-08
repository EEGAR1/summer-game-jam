extends Action

@onready var build_area: Area2D = $BuildArea

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var build_speed := 1.0

var overlp : Array[Area2D] : 
	get():
		return build_area.get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))
		
func _check_action(delta : float):
	animation_player.play("RESET")
	
	remove_action()
	for i in overlp:
		i = i as Building
		set_action()

func _while_acting(delta : float):
	animation_player.play("building")
	sprite_2d.flip_h = parent.icon.flip_h
	
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
