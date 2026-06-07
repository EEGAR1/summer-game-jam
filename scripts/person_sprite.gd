extends AnimatedSprite2D

@export var options : Array[SpriteFrames]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = options.pick_random()

func _process(delta: float) -> void:
	play(animation)
