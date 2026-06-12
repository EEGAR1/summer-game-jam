extends PlayerItem

var control_item_panel
var control_item_label

enum SELECTION_TYPE {
	MOVEBUILD,
	KILL
}
var select : SELECTION_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_hint = preload("uid://cn472bl2uam0t")
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	control_item_panel = Globals.control_item_panel
	control_item_label = Globals.control_item_label

var ovrlp : Array : 
	get(): 
		return Globals.mouse.get_overlapping_bodies().filter(func(x): return x is Person)

func _check_active(delta : float) -> bool:
	return true

var window_open := false
var label_showing := false
var target : Person
var paused := false

func _always(delta : float) -> void:
	if paused:
		Engine.time_scale = lerp(Engine.time_scale, 0.05, delta * 5)
		AudioServer.playback_speed_scale = lerp(AudioServer.playback_speed_scale, 0.05, delta * 5)
	else:
		Engine.time_scale = lerp(Engine.time_scale, 1.0, delta * 5)
		AudioServer.playback_speed_scale = lerp(AudioServer.playback_speed_scale, 1.0, delta * 5)
	
	control_item_panel.visible = window_open
	control_item_label.visible = label_showing

func _while_active(delta : float) -> void:
	if len(ovrlp) > 0 and Input.is_action_just_pressed("m2"):
		window_open = true
		target = ovrlp[0]
	
	if window_open:
		paused = true
		
		if Input.is_action_just_pressed("esc"):
			exit_control_item_panel()
	elif label_showing:
		if Input.is_action_just_pressed("m1"):
			var victim
			if len(ovrlp) > 0: victim = ovrlp[0]
			match select:
				SELECTION_TYPE.MOVEBUILD:
					target.set_movement_target(get_global_mouse_position())
					target.current_state = target.STATE.WORKING
					target.possessed = true
				SELECTION_TYPE.KILL:
					if len(ovrlp) <= 0: return
					var am = target.get_children().filter(func(x): return x is ActionManager)[0]
					var kill_action = am.get_children().filter(func(x): return x is KillAction)[0] as KillAction
					kill_action.set_action()
					target.set_movement_target(victim.global_position)
					target.emotion_manager.set_emotion(victim.id, EmotionManager.EMOTION_TYPE.LOVE, 0.0) # Make them HATE the target
					target.current_state = target.STATE.WORKING
					target.possessed = true
					
			exit_control_item_label()

func exit_control_item_panel():
	paused = false
	window_open = false

func open_control_item_label():
	paused = true
	label_showing = true

func exit_control_item_label():
	paused = false
	label_showing = false
	use()

func _on_option_button_item_selected(index: int) -> void:
	select = index as SELECTION_TYPE
	exit_control_item_panel()
	open_control_item_label()
