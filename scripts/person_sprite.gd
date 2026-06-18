extends AnimatedSprite2D

@export var options : Array[SpriteFrames]
@export var genders : Array[int]
@export var gender_names : Dictionary[int, Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sprite_frames = options.pick_random()
	var index = options.find(sprite_frames)
	get_parent().name = gender_names.get(genders[index]).pick_random() + " " + Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")).pick_random()

func _process(delta: float) -> void:
	play(animation)
