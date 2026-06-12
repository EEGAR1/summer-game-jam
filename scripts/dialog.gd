extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var text: Label = $Text
@onready var title: Label = $Title
@onready var option_button: OptionButton = $OptionButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var callback : Callable
func show_dialog(title_text : String, body_text : String, options : Array[String], callback : Callable) -> void:
	animation_player.play("open")
	title.text = title_text
	text.text = body_text
	
	for i in options:	option_button.add_item(i)
	
	self.callback = callback

func _on_option_button_item_selected(index: int) -> void:
	animation_player.play("close")
	callback.call(index)
