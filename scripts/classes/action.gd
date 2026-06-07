class_name Action extends Node2D

var parent : Person :
	get():
		return get_parent().get_parent() as Person

var parent_is_ready : bool : 
	get():
		return parent.current_state == Person.STATE.WORKING and len(parent.current_path.path) == 0

var current_action : Node2D :
	get():
		return get_parent().current_action
	set(value):
		get_parent().current_action = value

var is_current_action : bool :
	get():
		return parent.current_state == Person.STATE.USINGACTION and current_action == self

func _process(delta: float) -> void:
	if parent_is_ready:
		_check_action(delta)
	elif is_current_action:
		_while_acting(delta)
	else:
		_no_action(delta)

func _check_action(delta : float) -> void:
	pass

func _while_acting(delta : float) -> void:
	pass

func _no_action(delta : float) -> void:
	pass

func set_action() -> void:
	parent.current_state = Person.STATE.USINGACTION
	current_action = self

func remove_action() -> void:
	if current_action == self:
		current_action = null
