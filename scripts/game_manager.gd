extends Node

func _process(delta: float) -> void:
	if Globals.player.dead:
		Globals.defeat_control.visible = true
	elif len(Globals.other_people.map(func(x): return is_instance_valid(x))) == 0:
		Globals.victory_control.visible = true
