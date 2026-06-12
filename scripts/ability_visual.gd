extends Control

var ref : Node

var remaining_time : float
var active := false

@onready var cooldown_panel: Panel = $CooldownPanel
@onready var label: Label = $CooldownPanel/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_time = ref.current_time
	active = ref.active
	
	cooldown_panel.visible = !active
	label.text = str(round(remaining_time))
	label.visible = remaining_time > 0.0
