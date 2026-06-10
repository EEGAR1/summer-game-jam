extends Action

func _check_action(delta : float) -> void: # Should use `set_action()` to set this as the current action
	pass

func _while_acting(delta : float) -> void: # Plays while acting
	pass

func _no_action(delta : float) -> void: # Plays when there is no action
	pass

# Delete me in the final version of the action; this is just to see what it does
func set_action() -> void: # Use this to set this action as the current action. And yeah, it sets the state to using action, so be careful
	parent.current_state = Person.STATE.USINGACTION
	current_action = self

# Delete me in the final version of the action; this is just to see what it does
func remove_action() -> void: # Use this to remove whatever the current action is right now
	if current_action == self:
		current_action = null

func _parent_is_ready() -> bool: # This function returns `true` to check the current action and should be `false` when actually acting to stop other actions from happening in its place 
	# Below is the default behavior. You don't have to override this function if you want this
	return parent.current_state == Person.STATE.WORKING and len(parent.current_path.path) == 0 

func _is_current_action() -> bool: # This function should make sure that the Person is in the USINGACTION
	return parent.current_state == Person.STATE.USINGACTION and current_action == self
