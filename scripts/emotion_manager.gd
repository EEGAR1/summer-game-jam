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

var emotions : Dictionary[float, float] # The first float is X.Y where X is the id of the person and Y is the id of the emotion, and obv the second float is the emotion value
										# Ex: {5.1, 5.0} means that person of id 5 has a trust scale of 5.0

func set_emotion(person_id : int, em_type : int, value : float):
	var em_id = float(person_id) + 0.1*float(em_type)
	emotions.set(em_id, value)

func show_emotion(emotion : int, is_pos : bool):
	animated_sprite_2d.frame = emotion_update_sprites_pos[emotion] if is_pos else emotion_update_sprites_neg[emotion]
	animation_player.play("show")

func show_emotion_frame(frame : int):
	animated_sprite_2d.frame = frame
	animation_player.play("show")

func get_emotion(person_id : int, em_type : int):
	return emotions.get(float(person_id) + 0.1*float(em_type))

func _ready() -> void:
	if is_instance_valid(get_tree()):	await get_tree().process_frame
	
	for i in Globals.other_people:
		for emotion in EMOTION_TYPE.values():
			emotions.set(float(i.id) + 0.1*float(emotion), 50.0)
	
