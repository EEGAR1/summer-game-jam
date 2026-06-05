class_name Person extends CharacterBody2D

enum STATE {
	WORKING,
	SELECTED
}
var current_state := STATE.WORKING

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	match current_state:
		STATE.WORKING:
			print(mouse_over)
			# Select and move a worker
			if mouse_over and Input.is_action_just_pressed("m1"):
				current_state = STATE.SELECTED
			
			# Pathfind to target
			if navigation_agent.is_navigation_finished():
				return

			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()

			velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			move_and_slide()
		
		STATE.SELECTED:
			modulate = Color(1.224, 1.224, 1.224, 1.0)
			if Input.is_action_just_pressed("m1"):
				set_movement_target(get_global_mouse_position())
				current_state = STATE.WORKING



var mouse_over := false
func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
