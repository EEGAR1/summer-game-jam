class_name Person extends CharacterBody2D

@export_category("Internal Feelings")
@export var stress := 0.0 ## The higher the stress, the lower the threshold for action and the higher the speed
var can_command : bool :
	get():
		return emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST) > 75.0
var possessed : bool = false

@export_category("Physical Traits")
@export var max_speed := 50.0

enum STATE {
	WORKING,
	SELECTED,
	USINGACTION,
	DEAD
}
var current_state := STATE.WORKING

const BODY = preload("uid://ddaa6cd7rv0ym")
var dead := false :
	set(value):
		dead = value
		var b = BODY.instantiate()
		get_parent().add_child(b)
		b.global_position = global_position
		b.owner_id = id
		icon.animation = "dead"
		icon.z_index -= 1
		icon.reparent.call_deferred(b)
		queue_free.call_deferred()
	

var movement_speed: float = 1000.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var icon: AnimatedSprite2D = $Icon
@onready var emotion_manager: EmotionManager = $EmotionManager

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
	
	Globals.other_people.append(self)

func set_movement_target(movement_target: Vector2):
	if not Globals.hover_target: # If we are not hovering a POI, reduce grouping
		for i in target_positions:
			if target_positions.find(i) == id:	continue
			
			if i.distance_to(movement_target) < 16.0:
				movement_target += Vector2(cos(rand), sin(rand)) * 16.0
	
	navigation_agent.target_position = movement_target

var current_path : CustomPath = CustomPath.new()

var steps := 1
func path_postprocess():
	current_path.clear()
	current_path.translate(navigation_agent.get_current_navigation_path())

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
	
	if stress > 0.0: stress -= delta
	
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	navigation_agent.max_speed = max_speed + stress
	
	# Animations
	icon.animation = "idle" if velocity.length() < 0.1 or stopped else "run"
	if velocity.x != 0.0:	icon.flip_h = velocity.x < 0.0

	match current_state:
		STATE.WORKING:
			stopped = false
			
			# Select and move a worker
			if mouse_over and Input.is_action_just_pressed("m1") and can_command:
				current_state = STATE.SELECTED
		STATE.SELECTED:
			stopped = true
			modulate = Color(1.224, 1.224, 1.224, 1.0)
			if Input.is_action_just_pressed("m1"):
				set_movement_target(get_global_mouse_position())
				current_state = STATE.WORKING
		
		STATE.USINGACTION:
			#stopped = true
			pass
	
	pathfind_process(delta)
		
	target_positions.set(id, navigation_agent.target_position)

func pathfind_process(delta : float):
	# Pathfind to target
	if navigation_agent.is_navigation_finished() or global_position.distance_to(navigation_agent.target_position) < 5.0:
		navigation_agent.set_velocity(Vector2.ZERO)
		possessed = false
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = current_path.get_next_pos(global_position, velocity)

	var n_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	navigation_agent.set_velocity(n_velocity)


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
