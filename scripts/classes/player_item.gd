class_name PlayerItem extends Node2D

func _init() -> void:
	ready.connect(internal_ready)

var ability_hint : PackedScene
func internal_ready():
	if is_instance_valid(get_tree()):	await get_tree().process_frame
	var ah = ability_hint.instantiate()
	Globals.ability_holder.add_child(ah)
	ah.global_position = Globals.ability_holder.global_position
