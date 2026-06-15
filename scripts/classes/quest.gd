class_name Quest extends Node2D

@export var trust_factor := 100.0 # How much trust to give on completion
@export var parent : Person

@onready var quest_manager: QuestManager = get_parent()

func _init() -> void:
	ready.connect(internal_ready)

func internal_ready():
	quest_manager.current_quests.append(self as Quest)

func complete_quest() -> void:
	if not is_instance_valid(parent): return
	parent.emotion_manager.set_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST, parent.emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST) + trust_factor)
	parent.emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.TRUST, true)
	queue_free.call_deferred()

func incorrect_complete_quest() -> void:
	if not is_instance_valid(parent): return
	parent.emotion_manager.set_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST, parent.emotion_manager.get_emotion(Globals.player.id, EmotionManager.EMOTION_TYPE.TRUST) - trust_factor)
	parent.emotion_manager.show_emotion(EmotionManager.EMOTION_TYPE.LOVE, false)
	queue_free.call_deferred()
