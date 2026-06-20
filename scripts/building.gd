class_name Building extends POI

@export var work_needed := 7.5
var current_work := 0.0

enum STATE {
	PLACING,
	BUILDING,
	BUILT,
	DAMAGED
}
var current_state := STATE.PLACING

signal built

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	building_process(delta)
	
const PLACE = preload("uid://dsmebawnxgdg5")

var damaged := false
func building_process(delta : float):
	queue_redraw()
	match current_state:
		STATE.PLACING:
			sprite_2d.modulate = Color(0.0, 1.0, 0.0, 1.0)
			global_position = round(get_global_mouse_position() / 8) * 8
			if len(get_overlapping_bodies().filter(func(x): return x.is_in_group("Wall"))) != 0 or len(get_overlapping_areas().filter(func(x): return x is Building)) > 1:
					# Cant place
					sprite_2d.modulate = Color(1.0, 0.0, 0.0, 1.0)
					return
			
			if Input.is_action_just_pressed("m1"):
				Globals.play_sound(global_position, PLACE)
				Globals.camera.shake = 5.0
				current_state = STATE.BUILDING
		
		STATE.BUILDING:
			sprite_2d.modulate = Color(0.194, 0.194, 0.194, 1.0) if damaged else Color(0.784, 0.784, 0.784, 0.329)
			if damaged: damaged_process(delta)
			
			if current_work > work_needed:
				built.emit()
				current_state = STATE.BUILT
				damaged = false
		
		STATE.BUILT:
			sprite_2d.modulate = Color(1.0, 1.0, 1.0, 1.0)
			built_process(delta)
			pass
		
		STATE.DAMAGED:
			sprite_2d.modulate = Color(0.194, 0.194, 0.194, 1.0)
			current_state = STATE.BUILDING
			damaged = true
			current_work = 0.0

func built_process(delta : float) -> void:
	pass

func damaged_process(delta : float) -> void:
	pass

func _draw() -> void:
	if current_state == STATE.BUILDING:
		draw_arc(Vector2.ZERO, 4, 0.0, PI*2*(current_work/work_needed), 16, Color(1.0, 1.0, 1.0, 1.0), 2.0)
		
		
		
