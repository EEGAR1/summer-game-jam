class_name IdlePOI extends Node2D

@export var enabled := true : 
	set(value):
		if value:
			if not self in Globals.idle_pois:
				Globals.idle_pois.append(self)
		else:
			if self in Globals.idle_pois:
				Globals.idle_pois.remove_at(Globals.idle_pois.find(self))

func _ready() -> void:
	if enabled:	enabled = true

func _exit_tree() -> void:
	Globals.idle_pois.remove_at(Globals.idle_pois.find(self))
