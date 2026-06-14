extends Action

@onready var player_talk_action: PlayerTalkAction = $"../PlayerTalkAction"

var trust : float :
	get():
		return parent.emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST)

var last_player_trust := 0.0
func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	if trust > 75.0 and last_player_trust <= 75.0:
		print("yay! I like you!")
		player_talk_action.talk_state = PlayerTalkAction.TALK_TYPE.HEYIMJOINING
		player_talk_action.set_action()
	elif trust < 75.0 and last_player_trust >= 75.0:
		player_talk_action.talk_state = PlayerTalkAction.TALK_TYPE.HEYIMLEAVING
		player_talk_action.set_action()
	
	last_player_trust = trust

# Actually doesnt act on its own it uses player_talk_action to act instead
func _while_acting(delta : float) -> void: # Plays while acting
	pass

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

# Can trigger any time
func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	# Below is the default behavior. You don't have to override this function if you want this
	return !_is_current_action()

func _is_current_action() -> bool: # This function should make sure that the Person is in the USINGACTION
	return current_action == self
