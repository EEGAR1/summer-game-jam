extends Control

@onready var label: Label = $TooltipPanel/Label


var text : = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.tooltip = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = (get_global_mouse_position() - get_viewport_rect().position).clamp(Vector2(0, size.y), Vector2(get_viewport_rect().size.x - size.x, get_viewport_rect().size.y))
	
	label.text = text
