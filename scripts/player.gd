extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var speed := 50.0
@export var handling := 20.0

const dust = preload("res://effects/dust.tscn")
var can_spawn_footstep: bool = true
@onready var timer: Timer = $"footstep timer"


func _ready() -> void:
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
	
	if abs(velocity.x) > 0.1 or abs(velocity.y) > 0.1:
		if can_spawn_footstep:
			can_spawn_footstep = false
			timer.start()
			var p = dust.instantiate()
			p.emitting = true
			$"../CanvasLayer/SubViewportContainer/SubViewport".add_child(p)
			p.global_position.x = self.global_position.x
			p.global_position.y = self.global_position.y+9




			
	velocity = lerp(velocity, target, delta * handling)
	
	
	move_and_slide()


func _on_footstep_timer_timeout() -> void:
	can_spawn_footstep = true
