class_name Building extends Area2D

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
	queue_redraw()
	match current_state:
		STATE.PLACING:
			global_position = (get_global_mouse_position() / 16) * 16
			if Input.is_action_just_pressed("m1"):
				current_state = STATE.BUILDING
		STATE.BUILDING:
			for person in get_overlapping_bodies().filter(func(x): return x is Person):
				person = person as Person
				if person.current_state == Person.STATE.WORKING and collision_shape_2d.shape.get_rect().has_point(to_local(person.navigation_agent.target_position)):
					person.current_state = Person.STATE.BUILDING
				elif person.current_state == Person.STATE.BUILDING:
					current_work += delta
				
			if current_work > work_needed:
				built.emit()
				current_state = STATE.BUILT
		STATE.BUILT:
			pass

func _draw() -> void:
	if current_state == STATE.BUILDING:
		draw_arc(Vector2.ZERO, 4, 0.0, PI*2*(current_work/work_needed), 16, Color(1.0, 1.0, 1.0, 1.0), 2.0)
		
		
		
