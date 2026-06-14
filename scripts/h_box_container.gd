extends HBoxContainer

@onready var panel: Panel = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.ability_holder = self

func _process(delta: float) -> void:
	panel.custom_minimum_size = size
