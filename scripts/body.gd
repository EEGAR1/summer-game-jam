class_name Body extends Area2D

var owner_id := -1

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

const DIE = preload("uid://cv5o5axtl5ebm")
func _enter_tree() -> void:
	if is_instance_valid(get_tree()): await get_tree().process_frame
	Globals.play_sound(global_position, DIE)
	
	audio_stream_player_2d.play()
	audio_stream_player_2d_2.play()
