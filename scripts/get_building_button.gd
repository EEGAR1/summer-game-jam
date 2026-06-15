extends Button

@export var target_building : PackedScene
@export var building_name := "NAME ME YOU IDIOT!!!"

@onready var texture_rect: TextureRect = $TextureRect
@onready var foldable_container: FoldableContainer = $"../../.."
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tb = target_building.instantiate()
	for i in tb.get_children():
		if i is Sprite2D:
			texture_rect.texture = i.texture
	
	label.text = building_name
	
	pressed.connect(_pressed)
	

func _pressed() -> void:
	get_tree().current_scene.add_child(target_building.instantiate())
	foldable_container.fold()
