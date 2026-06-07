class_name POI extends Area2D

func _init() -> void:
	draw.connect(_draw_me)

func _draw_me():
	modulate = Color(1.62, 1.62, 1.62, 1.0) if self == Globals.hover_target else Color(1.0, 1.0, 1.0, 1.0)
