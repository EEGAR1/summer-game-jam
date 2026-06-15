extends FOVArea2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	animation_player.play("explode")

func damage() -> void:
	Globals.camera.shake = 15.0
	var buildings = get_fov_overlapping_areas().filter(func(x): return x is Building)
	var people = get_fov_overlapping_bodies().filter(func(x): return x is Person)
	
	for i in buildings:
		i = i as Building
		i.current_state = Building.STATE.DAMAGED
	
	for i in people:
		i = i as Person
		i.dead = true
