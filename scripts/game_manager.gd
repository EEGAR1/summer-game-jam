extends Node

func _process(delta: float) -> void:
	if Globals.player.dead:
		Globals.defeat_control.visible = true
	elif len(Globals.other_people.filter(func(x): return is_instance_valid(x))) == 1: # If you are the only survivor 
		Globals.victory_control.visible = true
