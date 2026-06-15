extends Action

@onready var player_talk_action: PlayerTalkAction = $"../PlayerTalkAction"

func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	if randi_range(0,2/delta) == 0 and parent.emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST) <= 75.0:
		player_talk_action.talk_state = PlayerTalkAction.TALK_TYPE.BUILDQUEST
		player_talk_action.set_action()

# Uses talk action. Doesn't do something on its own
func _while_acting(delta : float) -> void: # Plays while acting
	pass

func _no_action(delta : float) -> void: # Plays when there is no action
	pass
