class_name Player extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var speed := 50.0
@export var handling := 20.0

var id : int
func _ready() -> void:
	id = len(Globals.other_people)
	Globals.other_people.append(self)
	
	Globals.player = self

var dead := false
func _process(delta: float) -> void:
	sprite_2d.play(sprite_2d.animation)
	if dead:
		sprite_2d.play("dead")
	else:
		sprite_2d.animation = "idle" if velocity.length() < 10 else "run"
		if velocity.x != 0:	sprite_2d.flip_h = velocity.x < 0

func _physics_process(delta: float) -> void:
	var target := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	target *= speed
	
	velocity = lerp(velocity, target, delta * handling)

	move_and_slide()
