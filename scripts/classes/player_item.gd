class_name PlayerItem extends Node2D

@export var active := false
@export var cooldown_time := 0.0
@onready var current_time = cooldown_time
@export var ability_hint : PackedScene

func _init() -> void:
	ready.connect(internal_ready)


func internal_ready():
	if is_instance_valid(get_tree()):	await get_tree().process_frame
	var ah = ability_hint.instantiate()
	Globals.ability_holder.add_child(ah)
	ah.global_position = Globals.ability_holder.global_position
	ah.ref = self

func _process(delta: float) -> void:
	current_time -= delta
	
	_always(delta)
	
	active = _check_active(delta)
	
	if current_time > 0.0:
		active = false
		
	if !active:
		return
	else:
		_while_active(delta)
	
func _check_active(delta : float) -> bool:
	return false

func _while_active(delta : float) -> void:
	pass

func _always(delta : float) -> void:
	pass

func use() -> void:
	active = false
	current_time = cooldown_time
