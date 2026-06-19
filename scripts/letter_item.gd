class_name LetterPlayerItem extends PlayerItem

enum TYPES {
	GOOD,
	BAD
}
@export var type : TYPES
@export var from : Person
@export var to : Person

@onready var area_2d: Area2D = $Area2D
var ovrlp : Array :
	get():
		return area_2d.get_overlapping_bodies().filter(func(x): return x is Person)

func _ready() -> void:
	match type:
		TYPES.GOOD:
			ability_hint = preload("uid://dhuvflyd5rgxu")
		TYPES.BAD:
			ability_hint = preload("uid://dto5axtml4opp")
	
	texture_rect.texture = to.icon.sprite_frames.get_frame_texture("idle", 0)

func _check_active(delta : float) -> bool:
	return to in ovrlp
	
@onready var pointer: Node2D = $CanvasLayer/Pointer
@onready var texture_rect: TextureRect = $CanvasLayer/Pointer/Sprite2D/TextureRect
@onready var line_2d: Sprite2D = $CanvasLayer/Pointer/Sprite2D

func _always(delta : float) -> void:
	pointer.global_position = Globals.player.global_position
	pointer.rotation = (to.global_position - Globals.player.global_position).normalized().angle()
	line_2d.position.x = sqrt(to.global_position.distance_to(Globals.player.global_position) if to.global_position.distance_to(Globals.player.global_position) != 0 else 0.0000000001) * 2.25
	texture_rect.rotation = -pointer.rotation - deg_to_rad(45)

func _while_active(delta : float) -> void:
	if Input.is_action_just_pressed("give") and _check_active(delta):
		var target = to
		
		match type:
			TYPES.GOOD:
				if not is_instance_valid(from): return
				if not is_instance_valid(target): return
				target.emotion_manager.set_emotion(from.id + 1, EmotionManager.EMOTION_TYPE.LOVE, 80.0)
				target.emotion_manager.set_emotion(from.id + 1, EmotionManager.EMOTION_TYPE.TRUST, 75.0)
				target.emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.LOVE, true)
			TYPES.BAD:
				if not is_instance_valid(from): return
				if not is_instance_valid(target): return
				target.emotion_manager.set_emotion(from.id + 1, EmotionManager.EMOTION_TYPE.LOVE, target.emotion_manager.get_emotion(from.id, EmotionManager.EMOTION_TYPE.LOVE) - 20.0)
				target.emotion_manager.set_emotion(from.id + 1, EmotionManager.EMOTION_TYPE.TRUST, target.emotion_manager.get_emotion(from.id, EmotionManager.EMOTION_TYPE.TRUST) - 50.0)
				target.emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.LOVE, false)
			
		use()
		ah.queue_free.call_deferred()
		queue_free.call_deferred()
		
