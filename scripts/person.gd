class_name Person extends CharacterBody2D

@export var max_size := 30.0
@export var min_size := 8.0

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
	rand = randf_range(0, PI*2)
	
	id = len(target_positions)
	target_positions.append(Vector2.ZERO)
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	navigation_agent.path_changed.connect(path_postprocess)

func set_movement_target(movement_target: Vector2):
	if not Globals.hover_target: # If we are not hovering a POI, reduce grouping
		for i in target_positions:
			if target_positions.find(i) == id:	continue
			
			if i.distance_to(movement_target) < 10.0:
				movement_target += Vector2(cos(rand), sin(rand)) * 20.0
	
	navigation_agent.target_position = movement_target

var current_path : CustomPath = CustomPath.new()

var steps := 1
func path_postprocess():
	current_path.clear()
	current_path.translate(navigation_agent.get_current_navigation_path())
	current_path.path = [current_path.path[0], current_path.path[len(current_path.path) - 1]] # Strip path
	
	'''
	for step in range(steps):
		# Bump path points that go through other agents
		var last_link := global_position
		for link in current_path.get_path().duplicate():
			var index = current_path.get_path().find(link)
			var results = check_box_intersection(link, last_link, 16.0)
			for result in results:
				if result != {}:	if result.collider != self:	if result.collider is Person:
					# Calculate nudge
					var other_target = result.collider.global_position
					var sign_ = sign(link - other_target).x if abs(link.x - other_target.x) > abs(link.y - other_target.y) else sign(link - other_target).y
					var vector = (link - other_target).rotated(deg_to_rad(90 * sign_))
					current_path.add_link(index, other_target + vector.normalized() * 18.0)
			
			last_link = link
	'''

func check_box_intersection(from_pos: Vector2, to_pos: Vector2, box_width: float):
	var center = (from_pos + to_pos) / 2
	var direction = (to_pos - from_pos)
	var length = direction.length()
	var angle = direction.angle()
	
	var shape = RectangleShape2D.new()
	shape.size = Vector2(box_width, length)
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.transform = Transform2D(angle, center)
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	
	return result

var stopped := false
func _physics_process(delta):
	queue_redraw()
	
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	match current_state:
		STATE.WORKING:
			stopped = false
			
			# Select and move a worker
			if mouse_over and Input.is_action_just_pressed("m1"):
				current_state = STATE.SELECTED
			
			# Pathfind to target
			if navigation_agent.is_navigation_finished():
				navigation_agent.set_velocity(Vector2.ZERO)
				sensing() # if we are standing still, sense whats around us
				return
			
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = current_path.get_next_pos(global_position, velocity)

			var n_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			#if velocity.length() < 5.0:	n_velocity = -n_velocity
			navigation_agent.set_velocity(n_velocity)
		
		STATE.SELECTED:
			stopped = true
			modulate = Color(1.224, 1.224, 1.224, 1.0)
			if Input.is_action_just_pressed("m1"):
				set_movement_target(get_global_mouse_position())
				current_state = STATE.WORKING
		
		STATE.BUILDING:
			stopped = true
	
	target_positions.set(id, navigation_agent.target_position)

var mouse_over := false
func _on_mouse_entered() -> void:
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if stopped:
		velocity = Vector2.ZERO
	else:
		velocity = safe_velocity
	move_and_slide()
	
@onready var building_sense: Area2D = $BuildingSense
func sensing():
	for building in building_sense.get_overlapping_areas().filter(func(x): return x is Building):
		set_movement_target(building.global_position)

func _draw() -> void:
	draw_polyline(current_path.overall_path.map(func(x): return to_local(x)), Color(1.0, 0.0, 0.0, 1.0), 3.0)
	
