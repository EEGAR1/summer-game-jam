class_name IdlePOI extends Node2D

func _ready() -> void:
	Globals.idle_pois.append(self)
