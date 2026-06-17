class_name KillAction extends Action

@export var killing := false

@export var max_love_to_kill := 15.0 ## If someone loves a person this value or less they will kill them

@onready var emotion_manager: EmotionManager = $"../../EmotionManager"
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var seek_area: Area2D = $SeekArea
var seek_area_overlap : Array[Node2D] :
	get():
		return seek_area.get_overlapping_bodies().filter(func(x): return x is CharacterBody2D)

@onready var stab_area: Area2D = $StabArea
var stab_area_overlap : Array[Node2D] :
	get():
		return stab_area.get_overlapping_bodies().filter(func(x): return x is CharacterBody2D)

var target : CharacterBody2D = null
func _parent_is_ready() -> bool:
	if _is_current_action(): return false

	return update_target()

func update_target() -> bool:
	var t : CharacterBody2D
	
	var min_love := 9e9
	for person in seek_area_overlap:
		var e = emotion_manager.get_emotion(person.id, EmotionManager.EMOTION_TYPE.LOVE)
		if e < min_love and person != parent:
			min_love = e
			t = person
	
	if min_love < max_love_to_kill:
		target = t
		return true
	return false

func _no_action(delta : float) -> void:
	return

func kill() -> void:
	target.dead = true

func _is_current_action() -> bool:
	return current_action == self

func _check_action(delta : float):
	if randi_range(0, int(5/delta)) == 0 or parent.possessed:
		emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.LOVE, false) # Show the negative emotion of love (anger) when we are about to kill
		set_action()

func _while_acting(delta : float):
	parent.stress += delta
	if !is_instance_valid(target): 
		remove_action()
		parent.current_path.clear()
		return
	
	var stab_target = stab_area_overlap.filter(func(x): return x == target)
	
	sprite_2d.rotation = atan2(global_position.y - target.global_position.y, global_position.x - target.global_position.x)
	if len(parent.current_path.path) == 0:	parent.set_movement_target(target.global_position)
	if parent.current_state != Person.STATE.WORKING:	parent.current_state = Person.STATE.WORKING
	if len(stab_target) > 0:
		print(parent.emotion_manager.emotions, target)
		animation_player.play("stab")
		remove_action()
		parent.current_path.clear()
