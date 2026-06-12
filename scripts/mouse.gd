extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	Globals.mouse = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	global_position = lerp(global_position, get_global_mouse_position(), 30 * delta / Engine.time_scale)
	var overlp = get_overlapping_areas().filter(func(x): return x.is_in_group("POI"))
	if overlp != [] and overlp != null:	Globals.hover_target = overlp.back()
	else:	Globals.hover_target = null
	
	animated_sprite_2d.frame = 1 if Input.is_action_pressed("m1") else 0
	
