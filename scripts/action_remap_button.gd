extends Button

export(String) var action

signal input_changed

func _ready():
	set_process_unhandled_key_input(false)
	display_current_key()


func _toggled(button_pressed):
	get_tree().set_input_as_handled()
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "... Key"
		release_focus()
	else:
		display_current_key()


func _unhandled_key_input(event):
	# Note that you can use the _input callback instead, especially if
	# you want to work with gamepads.
	if event.is_pressed():
		remap_action_to(event)


func remap_action_to(event: InputEventKey):
	# We first change the event in this game instance.
	var list = InputMap.get_actions()
	var inmap = InputMap.get_action_list(action)
	var no_scan = event
	var old_event: InputEventKey
	no_scan.scancode = 0
	for action_event in inmap:
		if action_event is InputEventKey:
			InputMap.action_erase_event(action,action_event)
			old_event = action_event
	for map_action in list:
		if InputMap.action_has_event(map_action,event) or InputMap.action_has_event(map_action,no_scan) and not(map_action.begins_with("ui")) and map_action!=action:
			InputMap.action_erase_event(map_action,event)
			InputMap.action_erase_event(map_action,no_scan)
			InputMap.action_add_event(map_action,old_event)
	event.scancode = 0
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = InputMap.get_action_list(action)
	KeyPersistence.save_keymap()
	text = "%s Key" % OS.get_scancode_string(event.physical_scancode)
	emit_signal("input_changed",self)
	pressed = false


func display_current_key():
	var current_key
	for list_entry in InputMap.get_action_list(action):
		if list_entry is InputEventKey:
			current_key = list_entry
	if current_key == null: return
	text = "%s Key" % OS.get_scancode_string(current_key.physical_scancode)
