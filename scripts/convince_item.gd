extends PlayerItem

var ovrlp : Array : 
	get(): 
		return Globals.mouse.get_overlapping_bodies().filter(func(x): return x is Person)

func _check_active(delta : float) -> bool:
	return len(ovrlp) > 0

func _always(delta : float) -> void:
	pass

func _while_active(delta : float) -> void:
	if Input.is_action_just_pressed("convince"):
		var person = ovrlp[0] as Person
		person.emotion_manager.set_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST, 80.0)
