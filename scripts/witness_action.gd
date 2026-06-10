extends Action

@onready var area_2d: FOVArea2D = $Area2D
@onready var emotion_manager: EmotionManager = $"../../EmotionManager"

var seen_bodies : Array[Body] = []
func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	for body in area_2d.get_fov_overlapping_areas().filter(func(x): return x is Body):
		if not body in seen_bodies:
			seen_bodies.append(body)
			set_action()

func _while_acting(delta : float) -> void: # Plays while acting
	emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.TRUST, false)
	remove_action()

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	return !_is_current_action() # Always be able to act
