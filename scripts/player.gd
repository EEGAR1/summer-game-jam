extends CharacterBody2D

@export var speed := 50.0
@export var handling := 20.0

func _ready() -> void:
	Globals.player = self

func _physics_process(delta: float) -> void:
	var target := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	target *= speed
	
	velocity = lerp(velocity, target, delta * handling)

	move_and_slide()
