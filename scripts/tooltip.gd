extends Control

@onready var item_list: ItemList = $TooltipPanel/ItemList

var data : Dictionary : 
	set(value):
		if value != data:
			update(value)
		data = value
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.tooltip = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = (get_global_mouse_position() - get_viewport_rect().position).clamp(Vector2(0, size.y), Vector2(get_viewport_rect().size.x - size.x, get_viewport_rect().size.y))

func update(data_ : Dictionary) -> void:
	item_list.clear()
	item_list.add_item("Name")
	item_list.add_item("Love")
	item_list.add_item("Trust")
	
	print(data_)
	for i in data_.keys().filter(func(x): return round(x) - x == 0.0):
		var id = int(round(i))
		print(id)

		item_list.add_item(Globals.other_people[id].name, Globals.other_people[id].get_children().filter(func(x): return x is AnimatedSprite2D)[0].sprite_frames.get_frame_texture("idle", 0))
		for em in EmotionManager.EMOTION_TYPE.values():
			if data_.get(i + 0.1 * em) > 70.0:
				item_list.add_item("✓")
			elif data_.get(i + 0.1 * em) < 30.0:
				item_list.add_item("X")
			else:
				item_list.add_item("~")
