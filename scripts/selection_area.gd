extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	var col_shape_size = collision_shape_2d.shape.get_rect().size
	collision_shape_2d.position = col_shape_size / 2.0 * sign(get_global_mouse_position() - global_position)
	
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
	
	if monitoring:	for person in get_overlapping_bodies().filter(func(x): return x is Person):
		person.current_state = Person.STATE.SELECTED

func _draw() -> void:
	var size:Vector2 = collision_shape_2d.shape.get_rect().size
	var rect: = Rect2(-size.x * 0.5 + collision_shape_2d.position.x, -size.y * 0.5 + collision_shape_2d.position.y, size.x, size.y) 
	draw_rect(rect, Color(1.0, 1.0, 1.0, 0.475))
