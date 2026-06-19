class_name Explosion extends FOVArea2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum DAMAGE_TYPE {
	BUILDINGS,
	PEOPLE
}
var damage_type : DAMAGE_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	animation_player.play("explode")
	
const EXPLODE = preload("uid://c0x7pkon3ett8")
func damage() -> void:
	Globals.play_sound(global_position, EXPLODE)
	Globals.camera.shake = 5.0
	var buildings = get_fov_overlapping_areas().filter(func(x): return x is Building)
	var people = get_fov_overlapping_bodies().filter(func(x): return x is Person)
	var player = get_fov_overlapping_bodies().filter(func(x): return x is Player)
	
	match damage_type:
		DAMAGE_TYPE.BUILDINGS:
			for i in buildings:
				i = i as Building
				i.current_state = Building.STATE.DAMAGED
		DAMAGE_TYPE.PEOPLE:
			for i in people:
				i = i as Person
				i.dead = true
	
	if len(player) != 0:
		(player[0] as Player).dead = true
