class_name Building extends POI

@export var work_needed := 20.0
var current_work := 0.0

enum STATE {
	PLACING,
	BUILDING,
	BUILT
}
var current_state := STATE.PLACING

signal built

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	building_process(delta)

func building_process(delta : float):
	queue_redraw()
	match current_state:
		STATE.PLACING:
			global_position = round(get_global_mouse_position() / 16) * 16
			if Input.is_action_just_pressed("m1"):
				current_state = STATE.BUILDING
		
		STATE.BUILDING:
			if current_work > work_needed:
				built.emit()
				current_state = STATE.BUILT
		
		STATE.BUILT:
			pass

func _draw() -> void:
	if current_state == STATE.BUILDING:
		draw_arc(Vector2.ZERO, 4, 0.0, PI*2*(current_work/work_needed), 16, Color(1.0, 1.0, 1.0, 1.0), 2.0)
		
		
		
