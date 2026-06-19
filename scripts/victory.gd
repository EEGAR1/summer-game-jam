extends Panel

@onready var control_item_panel: Panel = $"../ControlItemPanel"
@onready var item_holder: HBoxContainer = $"../ItemHolder"
@onready var control_item_label: Label = $"../ControlItemLabel"
@onready var defeat_: Panel = $"../Defeat!"
@onready var tooltip: Control = $"../Tooltip"
@onready var h_box_container: HBoxContainer = $"../HBoxContainer"
@onready var control: Control = $"../Control"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.victory_control = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		control_item_panel.visible = false
		item_holder.visible = false
		control_item_label.visible = false
		defeat_.visible = false
		tooltip.visible = false
		h_box_container.visible = false
		control.visible = false
		
		Globals.paused = true
		Globals.timing = false
