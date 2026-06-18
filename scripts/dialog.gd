class_name Dialog extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.dialog = self

@onready var text: Label = $Title/Text
@onready var title: Label = $Title
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect
@onready var option_button: CustomGridContainer = $GridContainer

class DialogData:
	var title_text : String
	var body_text : String
	var options : Array 
	var callback : Callable
	var texture : Texture2D
	
	func _init(title_text : String, body_text : String, options : Array, callback : Callable, texture : Texture2D = null):
		self.title_text = title_text
		self.body_text = body_text
		self.options = options
		self.callback = callback
		self.texture = texture
	
func exec_dialog(dialog : DialogData):
	if dialog == null:	return
	animation_player.play("open")
	title.text = dialog.title_text
	text.text = dialog.body_text
	texture_rect.texture = null
	if dialog.texture != null:	texture_rect.texture = dialog.texture
	
	option_button.clear()
	for i in dialog.options:	option_button.add_item(i)
	
	callbacks.append(dialog.callback)

var dialogs : Array[DialogData]

var callbacks : Array[Callable]
func show_dialog(title_text : String, body_text : String, options : Array, callback : Callable, texture : Texture2D = null) -> void:
	dialogs.append(DialogData.new(title_text, body_text, options, callback) if texture == null else DialogData.new(title_text, body_text, options, callback, texture))
	exec_dialog(dialogs.back())

func _on_option_button_item_selected(index: int) -> void:
	animation_player.play("close")
	if len(callbacks) == 0:	return
	if not is_instance_valid(callbacks.back()): return
	callbacks.back().call(index)
	callbacks.pop_back()
	dialogs.pop_back()
	exec_dialog(dialogs.back())
	
