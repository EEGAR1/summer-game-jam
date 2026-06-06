class_name Person extends CharacterBody2D

enum STATE {
	WORKING,
	SELECTED,
	BUILDING
}
var current_state := STATE.WORKING

var movement_speed: float = 1000.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

static var target_positions : Array[Vector2]
var id := 0

var rand : float
func _ready():
	rand = randf_range(-PI/2, PI/2)
	
	id = len(target_positions)
	target_positions.append(Vector2.ZERO)
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func set_movement_target(movement_target: Vector2):
	for i in target_positions:
		if target_positions.find(i) == id:	continue
		
		if i.distance_to(movement_target) < 16.0:
			movement_target += Vector2(cos(rand), sin(rand)) * 20.0
	navigation_agent.target_position = movement_target
	
func _physics_process(delta):
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	match current_state:
		STATE.WORKING:
			# Select and move a worker
			if mouse_over and Input.is_action_just_pressed("m1"):
				current_state = STATE.SELECTED
			
			# Pathfind to target
			if navigation_agent.is_navigation_finished():
				navigation_agent.set_velocity(Vector2.ZERO)
				sensing() # if we are standing still, sense whats around us
				return
			
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()

			var n_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			navigation_agent.set_velocity(n_velocity)
		
		STATE.SELECTED:
			navigation_agent.set_velocity(Vector2.ZERO)
			modulate = Color(1.224, 1.224, 1.224, 1.0)
			if Input.is_action_just_pressed("m1"):
				set_movement_target(get_global_mouse_position())
				current_state = STATE.WORKING
		
		STATE.BUILDING:
			navigation_agent.set_velocity(Vector2.ZERO)
	
	target_positions.set(id, navigation_agent.target_position)



var mouse_over := false
func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	
@onready var building_sense: Area2D = $BuildingSense
func sensing():
	for building in building_sense.get_overlapping_areas().filter(func(x): return x is Building):
		set_movement_target(building.global_position)
