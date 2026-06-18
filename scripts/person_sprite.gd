extends AnimatedSprite2D

@export var options : Array[SpriteFrames]

var parent : Person :
	get(): 
		return (get_parent() as Person)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_frames = options.pick_random()
	
	if is_instance_valid(get_tree()): await get_tree().process_frame
	for i in Globals.other_people:
		if i is Player: continue
		i = i as Person
		if i.type == parent.type:
			for em in EmotionManager.EMOTION_TYPE.values():
				parent.emotion_manager.set_emotion(i.id, em, randf_range(35.0, 90.0))
		else:
			for em in EmotionManager.EMOTION_TYPE.values():
				parent.emotion_manager.set_emotion(i.id, em, randf_range(20.0, 65.0))
	print(parent.emotion_manager.emotions)

func _process(delta: float) -> void:
	play(animation)
