extends Node2D

# Score
var time := 0.0
var timing := true

func _ready():
	get_tree().connect("scene_changed", Callable(self, "_on_scene_changed"))

func _on_scene_changed():
	reset()

func reset():
	time = 0.0
	
const LAST_STAND = preload("uid://bsdeycddsuxsb")
var last_stand := false
func _process(delta: float) -> void:
	if timing: time += delta
	
	if paused:
		Engine.time_scale = lerp(Engine.time_scale, 0.05, delta * 5)
		AudioServer.playback_speed_scale = lerp(AudioServer.playback_speed_scale, 0.05, delta * 5)
	else:
		Engine.time_scale = lerp(Engine.time_scale, 1.0, delta * 5)
		AudioServer.playback_speed_scale = lerp(AudioServer.playback_speed_scale, 1.0, delta * 5)
	
	if len(other_people.filter(func(x): return is_instance_valid(x))) != 0 and len(other_people.filter(func(x): return is_instance_valid(x))) < 5 and !last_stand:
		play_sound_global(LAST_STAND)
		last_stand = true

# General
var player : Node
var mouse : Area2D
var ability_holder : Node
var victory_control : Control
var defeat_control : Control
var camera : Camera2D
var tooltip : Control
var control_item_panel : Control
var control_item_label : Control
var dialog : Dialog
var quest_manager : QuestManager
var paused := false

# Globals for building
var hover_target

# Globals for people
enum POI_TYPE {
	CITIZEN,
	ENGINEER,
	OFFICER
}
var idle_pois : Array[Node2D] # Pois that people may wander to
var other_people : Array[Node2D]

# Globals for buildings
var building_points : Array[Node2D]
var complement_buildings : Array[PackedScene]

func play_sound(pos : Vector2, audio : AudioStream, pitchshift := 1.0):
	pitchshift *= randf_range(0.95, 1.05)
	var a = AudioStreamPlayer2D.new()
	a.autoplay = true
	a.pitch_scale = pitchshift
	a.stream = audio
	a.max_distance = 250.0
	a.volume_db = -10.0

	add_child(a)
	a.global_position = pos

func play_sound_global(audio : AudioStream):
	var a = AudioStreamPlayer.new()
	a.autoplay = true
	a.stream = audio

	add_child(a)
