extends Node2D

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

func set_emotion(em_id : float, value : float):
	if abs(value - emotions.get(em_id)) > 5.0:
		animated_sprite_2d.current_frame = emotion_update_sprites_pos[int(round(em_id))] if value - emotions.get(em_id) > 0.0 else emotion_update_sprites_neg[int(round(em_id))]
		animation_player.play("show")

func _ready() -> void:
	if is_instance_valid(get_tree()):	await get_tree().process_frame
	
	for i in Globals.other_people:
		for emotion in EMOTION_TYPE.values():
			emotions.set(float(i.id) + 0.1*float(emotion), 50.0)
	
