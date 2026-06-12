extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.victory_control = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		get_tree().paused = true
