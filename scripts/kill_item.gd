extends PlayerItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_hint = preload("uid://c8c6xdt3daq2m")

@onready var area_2d: Area2D = $Area2D
var ovrlp : Array :
	get():
		return area_2d.get_overlapping_bodies().filter(func(x): return x is Person)

func _check_active(delta : float) -> bool:
	print(len(ovrlp) > 0)
	return len(ovrlp) > 0

func _while_active(delta : float) -> void:
	if Input.is_action_just_pressed("kill"):
		var target = ovrlp[0] as Person
		target.dead = true
		use()
