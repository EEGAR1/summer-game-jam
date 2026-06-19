extends Button

@export_file("*.tscn") var next_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_pressed)


func _pressed() -> void:
	Globals.get_tree().change_scene_to_file(next_scene)
