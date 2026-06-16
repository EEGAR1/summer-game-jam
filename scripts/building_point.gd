@tool
extends Node2D

@export var forwhat : PackedScene : 
	set(value):
		forwhat = value
		if Engine.is_editor_hint():	
			for i in get_children():	i.queue_free()
			add_child(forwhat.instantiate())

var id : int : 
	get():
		return Globals.building_points.find(self)
	
func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	Globals.building_points.append(self)
	Globals.complement_buildings.append(forwhat)

func _exit_tree() -> void:
	if Engine.is_editor_hint(): return
	Globals.building_points.remove_at(id)
	Globals.complement_buildings.remove_at(id)
