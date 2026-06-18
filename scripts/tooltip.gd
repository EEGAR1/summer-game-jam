extends Control

@onready var item_list: ItemList = $TooltipPanel/ItemList

var data : Dictionary : 
	set(value):
		data = value
		update()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.tooltip = self

@onready var tooltip_panel: Panel = $TooltipPanel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tooltip_panel.custom_minimum_size = item_list.size
	position = (get_global_mouse_position() - get_viewport_rect().position).clamp(Vector2(0, size.y), Vector2(get_viewport_rect().size.x - size.x, get_viewport_rect().size.y))

func update() -> void:
	item_list.clear()
	item_list.add_item("Name")
	item_list.add_item("Love")
	item_list.add_item("Trust")
	
	for i in data.keys().filter(func(x): return round(x) - x == 0.0):
		var id = int(round(i))
		
		if not is_instance_valid(Globals.other_people[id]): continue
		
		item_list.add_item(Globals.other_people[id].name, Globals.other_people[id].get_children().filter(func(x): return x is AnimatedSprite2D)[0].sprite_frames.get_frame_texture("idle", 0))
		for em in EmotionManager.EMOTION_TYPE.values():
			if data.get(i + 0.1 * em) > 70.0:
				item_list.add_item("✓")
			elif data.get(i + 0.1 * em) < 30.0:
				item_list.add_item("X")
			else:
				item_list.add_item("~")
