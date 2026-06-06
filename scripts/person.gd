class_name Person extends CharacterBody2D

enum STATE {
	WORKING,
	SELECTED,
	BUILDING
}
var current_state := STATE.WORKING

var movement_speed: float = 1000.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func set_movement_target(movement_target: Vector2):
	if movement_target.distance_to(global_position) < 16.0:	return
	navigation_agent.target_position = movement_target + Vector2(randi_range(-8,8),randi_range(-8,8))
	
func _physics_process(delta):
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	match current_state:
		STATE.WORKING:
			# Select and move a worker
			if mouse_over and Input.is_action_just_pressed("m1"):
				current_state = STATE.SELECTED
			
			# Pathfind to target
			if navigation_agent.is_navigation_finished():
				return
			
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()

			var n_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			navigation_agent.set_velocity(n_velocity)
			

		
		STATE.SELECTED:
			modulate = Color(1.224, 1.224, 1.224, 1.0)
			if Input.is_action_just_pressed("m1"):
				set_movement_target(get_global_mouse_position())
				current_state = STATE.WORKING
		
		STATE.BUILDING:
			



var mouse_over := false
func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
