extends Area2D




	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.dialog.show_dialog("Sticky Note on Floor", "Oh and you can also build buildings and explode everyone with o2 cans, by the way. It's more efficent than stabbing people. You have to instruct the people to build stuff for you. Click the buildings dropdown to see what you can build.", ["Leave"], func(x): return x)
