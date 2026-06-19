class_name Player extends CharacterBody2D

@onready var items_manager: Node2D = $ItemsManager

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var speed := 70.0
@export var handling := 20.0

const dust = preload("res://effects/dust.tscn")

var can_spawn_footstep : bool = true

var id : int
func _ready() -> void:
	id = len(Globals.other_people)
	Globals.other_people.append(self)
	
	Globals.player = self

var awake := false :
	set(value):
		if value != awake:
			_on_wake()
		awake = value

func _on_wake():
	Globals.dialog.show_dialog("Note Inside Shoe", "Alright, you're in. Get past this guard by whatever means. Do nice things for people so they build dangerous buildings for you or just stab them. I don't care how it gets done. Signed: P.S.Y.O.P. & Killing Co.", ["Got it. (Close)"], func(x): return x)

var dead := false
func _process(delta: float) -> void:
	if velocity.length() > 0.25:
		awake = true
	
	sprite_2d.play(sprite_2d.animation)
	if dead:
		sprite_2d.play("dead")
	elif awake:
		sprite_2d.animation = "idle" if velocity.length() < 10 else "run"
		if velocity.x != 0:	sprite_2d.flip_h = velocity.x < 0

func _physics_process(delta: float) -> void:
	var target := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	target *= speed
	
	velocity = lerp(velocity, target, delta * handling)
	
	
	if abs(velocity.x) > 0.1 or abs(velocity.y) > 0.1:
		if can_spawn_footstep:
			can_spawn_footstep = false
			timer.start()
			var p = dust.instantiate()
			p.emitting = true
			$".".add_child(p)
			p.global_position.x = $".".global_position.x
			p.global_position.y = $".".global_position.y+9
			if randf() < .33:
				for i in range(2):
					print("for")
					var a = dust.instantiate()
					a.emitting = true
					$".".add_child(a)
					a.global_position.x = $".".global_position.x
					a.global_position.y = $".".global_position.y+9
					
	move_and_slide()

	

	
	


func _on_timer_timeout() -> void:
	can_spawn_footstep = true
