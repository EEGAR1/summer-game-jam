class_name EmotionManager extends Node2D

@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var emotion_number := 2
enum EMOTION_TYPE {
	LOVE,
	TRUST
}
@export var emotion_update_sprites_pos : Array[int]
@export var emotion_update_sprites_neg : Array[int]
@export var emotion_update_sounds_per_frame : Array[AudioStream]

var emotions : Dictionary[float, float] # The first float is X.Y where X is the id of the person and Y is the id of the emotion, and obv the second float is the emotion value
										# Ex: {5.1, 5.0} means that person of id 5 has a trust scale of 5.0

func set_emotion(person_id : int, em_type : int, value : float):
	var em_id = float(person_id) + 0.1*float(em_type)
	emotions.set(em_id, clamp(value, 0.0, 100.0))

func show_emotion(emotion : int, is_pos : bool):
	animated_sprite_2d.frame = emotion_update_sprites_pos[emotion] if is_pos else emotion_update_sprites_neg[emotion]
	animation_player.play("show")

var showing_frame : int = -1 : 
	set(value):
		if value != showing_frame:
			Globals.play_sound(global_position, emotion_update_sounds_per_frame[value])
		showing_frame = value

func show_emotion_frame(frame : int):
	showing_frame = frame
	animated_sprite_2d.frame = frame
	animation_player.play("show")

func get_emotion(person_id : int, em_type : int):
	return emotions.get(float(person_id) + 0.1*float(em_type))

var parent : Person :
	get():
		return get_parent() as Person

func _ready() -> void:
	if is_instance_valid(get_tree()):	await get_tree().process_frame
	
	for i in Globals.other_people:
		for emotion in EMOTION_TYPE.values():
			emotions.set(float(i.id) + 0.1*float(emotion), 50.0)
	
	for i in Globals.other_people:
		if i is Player: continue
		i = i as Person
		if i.type == parent.type:
			for em in EmotionManager.EMOTION_TYPE.values():
				parent.emotion_manager.set_emotion(i.id, em, randf_range(35.0, 90.0))
		else:
			for em in EmotionManager.EMOTION_TYPE.values():
				parent.emotion_manager.set_emotion(i.id, em, randf_range(20.0, 65.0))
