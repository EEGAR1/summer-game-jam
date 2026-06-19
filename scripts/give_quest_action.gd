extends Action

@onready var player_talk_action: PlayerTalkAction = $"../PlayerTalkAction"

static var giving_givequest := false

func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	if randi_range(0,25/delta) == 0 and parent.emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST) <= 75.0:
		player_talk_action.talk_state = PlayerTalkAction.TALK_TYPE.BUILDQUEST
		player_talk_action.set_action()
	elif randi_range(0,30/delta) == 0 and (parent.emotion_manager.emotions.values().max() >= 60.0 or parent.emotion_manager.emotions.values().min() <= 40.0) and not LetterPlayerItem in Globals.player.items_manager.get_children() and !giving_givequest:
		player_talk_action.talk_state = PlayerTalkAction.TALK_TYPE.GIVEQUEST
		player_talk_action.set_action()
		giving_givequest = true

# Uses talk action. Doesn't do something on its own
func _while_acting(delta : float) -> void: # Plays while acting
	pass

func _no_action(delta : float) -> void: # Plays when there is no action
	pass
