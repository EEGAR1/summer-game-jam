extends Quest

@onready var building_complement: Area2D = $"." # Since this is on an Area but Quest extends Node2D i'm using this for access

@export var target_building : PackedScene

var overlp : Array :
	get():
		return building_complement.get_overlapping_areas().filter(func(x): return x is Building).filter(func(x): return x.current_state == Building.STATE.BUILT)

func _ready() -> void:
	var tb = target_building.instantiate()
	for i in tb.get_children():
		add_child(i.duplicate())
	
	for i in get_children():
		if not i is Sprite2D:	continue
		i = i as Sprite2D
		i.modulate = Color(3.046, 0.395, 0.395, 0.596)

func _process(delta: float) -> void:
	if len(overlp) > 0:
		complete_quest()
