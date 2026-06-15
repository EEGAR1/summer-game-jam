class_name PlayerTalkAction extends Action

enum TALK_TYPE {
	HEYIMJOINING,
	HEYIMLEAVING,
	BUILDQUEST
}
var talk_state : TALK_TYPE

@export var body_text : Dictionary[TALK_TYPE, String]
@export var choices : Dictionary[TALK_TYPE, Variant] # Dictionary[TALK_TYPE, Array[String]]
var callables : Dictionary[TALK_TYPE, Callable] = {
	TALK_TYPE.HEYIMJOINING : callback_hey_im_joining, # Defaults
	TALK_TYPE.HEYIMLEAVING : callback_hey_im_leaving,
	TALK_TYPE.BUILDQUEST : callback_build_quest
}

func callback_hey_im_joining(index : int):
	print("player selected ", index)
	parent.can_command = true

func callback_hey_im_leaving(index : int):
	print("player selected ", index)
	parent.can_command = false

const BUILDING_COMPLEMENT = preload("uid://tbtxxel5mkwm")
@export var building_list : Array[PackedScene] = [preload("uid://d1i8a0emugm8w")]
func callback_build_quest(index : int):
	if index == 0:
		var bc = BUILDING_COMPLEMENT.instantiate()
		bc.target_building = building_list.pick_random()
		bc.parent = parent
		Globals.quest_manager.add_child(bc)

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
	if len(talk_ovrlp) != 0:
		Globals.dialog.show_dialog(parent.name, body_text.get(talk_state), choices.get(talk_state), callables.get(talk_state))
		remove_action()
	elif len(seek_ovrlp) != 0:
		if len(parent.current_path.path) <= 0:
			parent.set_movement_target(seek_ovrlp[0].global_position)

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	# Below is the default behavior. You don't have to override this function if you want this
	return !_is_current_action()

func _is_current_action() -> bool: # This function should make sure that the Person is in the USINGACTION
	return current_action == self
