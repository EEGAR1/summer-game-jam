extends Node2D

@export var length := 0.1
@export var streams : Array[AudioStreamWAV]
@export var icon : AnimatedSprite2D
var time := length

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if icon.animation != "run": 
		time = length
		return
	if time > length:
		time = 0.0
		Globals.play_sound(global_position, streams.pick_random())
