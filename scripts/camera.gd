extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.camera = self

var shake := 0.0
var shake_mod : Vector2
func _process(delta: float) -> void:
	if is_instance_valid(Globals.player):	global_position = Globals.player.global_position + shake_mod
	if shake > 0.0:
		shake -= shake * delta * 5.0
		shake_mod = Vector2(randi_range(-shake, shake), randi_range(-shake, shake))
