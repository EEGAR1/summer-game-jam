class_name CustomGridContainer extends GridContainer

signal _on_option_button_item_selected(index : int)

var buttons : Array[Button]

func _ready() -> void:
	clear()

func clear():
	buttons.clear()
	for i in get_children():
		i.queue_free.call_deferred()
	
func add_item(i : String):
	var b = Button.new()
	b.text = i
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(b)
	b.pressed.connect(_clicked)
	buttons.append(b)

func _clicked():
	var index := -1
	for i in get_children():
		index += 1
		i = i as Button
		if i.button_pressed:
			_on_option_button_item_selected.emit(index)
			return
