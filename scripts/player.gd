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
	Globals.dialog.show_dialog("Note Inside Shoe", "You’ve finally been elected leader of this colony! Now, your mission is to kill everyone on board, and don’t feel bad if your orders have some lies mixed in. Test your powers out on this guard, and remember, don’t get caught. Signed P.S.Y.O.P & Killing Co.", ["Got it. (Close)", "...what? (Also Close)"], func(x): return x)

var dead := false :
	set(value):
		if dead != value:
			var bb = BLOOD_BIG.instantiate() as CPUParticles2D
			var bs = BLOOD_SPLASH.instantiate() as CPUParticles2D
			
			get_parent().add_child(bb)
			bb.global_position = global_position
			bb.emitting = true
			
			get_parent().add_child(bs)
			bs.global_position = global_position
			bs.emitting = true
		dead = value

const BLOOD_BIG = preload("uid://dewsrgbxekfjk")
const BLOOD_SPLASH = preload("uid://iixrltb01wlu")
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
