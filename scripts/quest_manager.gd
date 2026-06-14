class_name QuestManager extends Node

var current_quests : Array[Quest]

func _ready() -> void:
	Globals.quest_manager = self
