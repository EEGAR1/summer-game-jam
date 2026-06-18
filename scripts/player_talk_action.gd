class_name PlayerTalkAction extends Action

enum TALK_TYPE {
	HEYIMJOINING,
	HEYIMLEAVING,
	BUILDQUEST,
	GIVEQUEST
}
var talk_state : TALK_TYPE

@export var body_text : Dictionary[TALK_TYPE, String]
@export var choices : Dictionary[TALK_TYPE, Variant] # Dictionary[TALK_TYPE, Array[String]]
var callables : Dictionary[TALK_TYPE, Callable] = {
	TALK_TYPE.HEYIMJOINING : callback_hey_im_joining, # Defaults
	TALK_TYPE.HEYIMLEAVING : callback_hey_im_leaving,
	TALK_TYPE.BUILDQUEST : callback_build_quest,
	TALK_TYPE.GIVEQUEST : callback_letter_quest
}

func callback_hey_im_joining(index : int):
	print("player selected ", index)
	parent.can_command = true

func callback_hey_im_leaving(index : int):
	print("player selected ", index)
	parent.can_command = false

const BUILDING_COMPLEMENT = preload("uid://tbtxxel5mkwm")
@export var building_list : Array[PackedScene] = [preload("uid://d1i8a0emugm8w")]

var choice
var point
var pos
func callback_build_quest(index : int):
	if index == 0:
		var bc = BUILDING_COMPLEMENT.instantiate()
		bc.target_building = choice
		bc.parent = parent
		bc.global_position = pos
		Globals.quest_manager.add_child(bc)
		
const LETTER_ITEM = preload("uid://ddjg8caagspb2")
@onready var give_quest_action: Node2D = $"../GiveQuestAction"
var to
func callback_letter_quest(index : int):
	give_quest_action.giving_givequest = false
	if index == 0:
		var li = LETTER_ITEM.instantiate() as LetterPlayerItem
		li.from = parent
		var max = 0
		var ind = -1
		var what_index = 0
		for i in parent.emotion_manager.emotions.values():
			ind += 1
			if abs(50.0 - i) > max:
				max = abs(50.0 - i)
				what_index = ind
		li.type = LetterPlayerItem.TYPES.GOOD if parent.emotion_manager.emotions.values()[what_index] >= 50.0 else LetterPlayerItem.TYPES.BAD
		li.to = to
		(Globals.player.get_child(2) as ItemsManager).add_child(li)

func no_duplicates(of: Array) -> Array:
	var dict := {}
	for i in of:
		dict.set(i, "something")
	return dict.keys()

@onready var seek_area: Area2D = $SeekArea
@onready var talk_area: Area2D = $TalkArea
var seek_ovrlp : Array :
	get():
		return seek_area.get_overlapping_bodies().filter(func(x): return x == Globals.player)
var talk_ovrlp : Array :
	get():
		return talk_area.get_overlapping_bodies().filter(func(x): return x == Globals.player)


func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	pass

func _while_acting(delta : float) -> void: # Plays while acting
	if len(Globals.complement_buildings) == 0:
		remove_action()
		return
	
	if len(talk_ovrlp) != 0:
		var texture = null
		match talk_state:
			TALK_TYPE.BUILDQUEST:
				choice = no_duplicates(Globals.complement_buildings).pick_random()
				point = Globals.building_points[Globals.building_points.filter(func(x): return x.forwhat == choice).map(func(x): return x.id).pick_random()]
				pos = point.global_position
				point.queue_free.call_deferred()
				texture = choice.instantiate().get_children().filter(func(x): return x is Sprite2D)[0].texture
			TALK_TYPE.GIVEQUEST:
				var max = 0
				var ind = -1
				var what_index = 0
				for i in parent.emotion_manager.emotions.values():
					ind += 1
					if abs(50.0 - i) > max:
						max = abs(50.0 - i)
						what_index = ind
				to = Globals.other_people[int(round(parent.emotion_manager.emotions.keys()[what_index]))]
				texture = (to.get_child(2) as AnimatedSprite2D).sprite_frames.get_frame_texture("idle", 0)
		Globals.dialog.show_dialog(parent.name, body_text.get(talk_state), choices.get(talk_state), callables.get(talk_state), texture)
	
		remove_action()
		return
	elif len(seek_ovrlp) != 0:
		if len(parent.current_path.path) <= 0:
			parent.set_movement_target(seek_ovrlp[0].global_position)
	
	parent.emotion_manager.show_emotion_frame(5)

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	# Below is the default behavior. You don't have to override this function if you want this
	return !_is_current_action()

func _is_current_action() -> bool: # This function should make sure that the Person is in the USINGACTION
	return current_action == self
