class_name PersonOutline extends Sprite2D

@onready var person: Person = $".."

enum STATE {
	OFF,
	ON,
	SLECTED
}
var current_state : STATE

func _ready() -> void:
	material = material.duplicate()

func _process(delta: float) -> void:
	if person.current_state == Person.STATE.SELECTED:
		current_state = STATE.SLECTED
	else:
		current_state = STATE.ON if person.can_command else STATE.OFF
	
	match current_state:
		STATE.OFF:
			visible = false
		STATE.ON:
			visible = true
			material.set("shader_parameter/dash_ratio", 0.5)
		STATE.SLECTED:
			visible = true
			material.set("shader_parameter/dash_ratio", 1.0)
