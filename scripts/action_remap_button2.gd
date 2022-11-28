extends Button

export(String) var action
signal input_changed

func _ready():
	set_process_unhandled_input(false)
	display_current_key()


func _toggled(button_pressed):
	get_tree().set_input_as_handled()
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "... Button"
		release_focus()
	else:
		display_current_key()


func _unhandled_input(event: InputEvent):
	# Note that you can use the _input callback instead, especially if
	# you want to work with gamepads.
	if event is InputEventJoypadButton and event.is_pressed():
		remap_action_to(event)
		pressed = false


func remap_action_to(event):
	# We first change the event in this game instance.
	var list = InputMap.get_actions()
	var inmap = InputMap.get_action_list(action)
	for map_action in list:
		if InputMap.action_has_event(map_action,event) and not(map_action.begins_with("ui")):
			InputMap.action_erase_event(map_action,event)
	for action_event in inmap:
		if action_event is InputEventJoypadButton:
			InputMap.action_erase_event(action,action_event)
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = InputMap.get_action_list(action)
	KeyPersistence.save_keymap()
	var index = event.button_index
	text = "Button " + str(index)
	emit_signal("input_changed",self)


func display_current_key():
	var button: int
	for list_entry in InputMap.get_action_list(action):
		if list_entry is InputEventJoypadButton:
			button = list_entry.button_index
	text = "Button " + str(button)
