extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var col_shape_size = collision_shape_2d.shape.get_rect().size
	var col_shape_pos = collision_shape_2d.shape.get_rect().position
	collision_shape_2d.position = col_shape_size / 2.0 * sign(get_global_mouse_position() - global_position)
	color_rect.size = col_shape_size
	color_rect.position = col_shape_pos * 2.0
	
	if Input.is_action_just_pressed("m1"):
		global_position = get_global_mouse_position()
		collision_shape_2d.shape.set("size", Vector2.ZERO)
	elif Input.is_action_pressed("m1"):
		monitoring = true
		if (col_shape_size.x * col_shape_size.y) > 500.0: visible = true
		collision_shape_2d.shape.set("size", abs(get_global_mouse_position() - global_position))
	elif Input.is_action_just_released("m1"):
		monitoring = false
		visible = false
	
	for person in get_overlapping_bodies().filter(func(x): return x is Person):
		person.current_state = Person.STATE.SELECTED
