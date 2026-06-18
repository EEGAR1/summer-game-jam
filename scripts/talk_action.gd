extends Action

@export var freq := 1
@export var time := 3.0

@onready var seek_area: Area2D = $SeekArea
var seek_ovrlp : Array : 
	get():
		return seek_area.get_overlapping_bodies().filter(func(x): return x is Person).filter(func(x): return parent.emotion_manager.get_emotion(x.id, EmotionManager.EMOTION_TYPE.TRUST) > 70.0) 
@onready var talk_area: Area2D = $TalkArea
var talk_ovrlp : Array : 
	get():
		return talk_area.get_overlapping_bodies().filter(func(x): return x is Person).filter(func(x): return parent.emotion_manager.get_emotion(x.id, EmotionManager.EMOTION_TYPE.TRUST) > 70.0) 


func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	var rand = randi_range(0, int(freq/(delta * (parent.stress * 2.0 + 1))))
	if rand == 0:
		var vals = parent.emotion_manager.emotions.values()
		if vals.min() < 30.0 or vals.max() > 70.0:  
			set_action() # If we hate or distrust someone enough, we'll talk about them, same for love and trust

var talk_time := 0.0
func _while_acting(delta : float) -> void: # Plays while acting
	if talk_time > time:
		remove_action()
		talk_time = 0.0
		return
	
	var target
	if len(talk_ovrlp) != 0:
		talk_time += delta
		
		target = talk_ovrlp[0] as Person
		
		# Make them stop and listen
		target.action_manager.current_action = null
		target.current_path.clear()
		
		for i in parent.emotion_manager.emotions.keys():
			var id = int(round(i))
			var em_type = int((i-int(round(i))) * 10)
			if parent.emotion_manager.get_emotion(id, em_type) < 70.0:	continue
			target.emotion_manager.set_emotion(id, em_type, target.emotion_manager.get_emotion(id, em_type) + (parent.emotion_manager.get_emotion(id, em_type) - target.emotion_manager.get_emotion(id, em_type)) * delta)
			print(target.emotion_manager.get_emotion(id, em_type))
	elif len(seek_ovrlp) != 0:
		target = seek_ovrlp[0] as Person
		if len(parent.current_path.path) == 0:
			parent.set_movement_target(target.global_position)
	else:
		remove_action()
		talk_time = 0.0
		return

func _no_action(delta : float) -> void: # Plays when there is no action
	pass
