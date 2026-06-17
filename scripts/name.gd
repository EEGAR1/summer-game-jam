extends Label

@export var target : Node2D

func _process(delta: float) -> void:
	text = target.name
	global_position = (target.global_position - Globals.camera.global_position + Vector2(0, -10)) * Globals.camera.zoom + get_viewport_rect().size / 2.0 - size / 2.0
