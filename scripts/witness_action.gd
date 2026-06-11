extends Action

@onready var area_2d: FOVArea2D = $Area2D
@onready var emotion_manager: EmotionManager = $"../../EmotionManager"

var seen_bodies : Array[Body] = []
func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	for body in area_2d.get_fov_overlapping_areas().filter(func(x): return x is Body):
		if not body in seen_bodies:
			seen_bodies.append(body)
			if not current_action is KillAction: set_action()

func _while_acting(delta : float) -> void: # Plays while acting
	emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.TRUST, false)
	parent.stress += 10.0
	for person in area_2d.get_fov_overlapping_bodies().filter(func(x): return x is Person):
		person = person as Person
		for emotion in EmotionManager.EMOTION_TYPE.values():
			emotion_manager.set_emotion(person.id, emotion, emotion_manager.get_emotion(person.id, emotion) - 8.0) # Trust and love the killer a little less 
		
		var action_manager = (person.get_children().filter(func(x): return x is ActionManager)[0] as ActionManager)
		var kill_action = (action_manager.get_children().filter(func(x): return x is KillAction)[0] as KillAction)
		var kill_anim_playing = kill_action.animation_player.is_playing()
		if kill_anim_playing:
			# We know that this person killed the body we see
			for emotion in EmotionManager.EMOTION_TYPE.values():
				emotion_manager.set_emotion(person.id, emotion, emotion_manager.get_emotion(person.id, emotion) - (emotion_manager.get_emotion(seen_bodies.back().owner_id, emotion) - 50.0)) 
			emotion_manager.show_emotion_frame(1)
			remove_action()
			return
		else:
			print("i'm sus of you")
			pass
			
	remove_action()

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	return !_is_current_action() # Always be able to act
