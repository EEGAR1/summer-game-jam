extends AnimatedSprite2D

@export var target : Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _enter_tree() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	
	animation_player.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = lerp(global_position, target, delta / 2.0)
