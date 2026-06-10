extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	play("default")
