extends Button

export(String) var action = "ui_up"

signal input_changed

func _ready():
	set_process_unhandled_key_input(false)
	display_current_key()


func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "... Key"
		release_focus()
		emit_signal("input_changed",self)
	else:
		display_current_key()


func _unhandled_key_input(event):
	# Note that you can use the _input callback instead, especially if
	# you want to work with gamepads.
	remap_action_to(event)
	pressed = false


func remap_action_to(event):
	# We first change the event in this game instance.
	var list = InputMap.get_actions()
	for map_action in list:
		if InputMap.action_has_event(map_action,event):
			InputMap.action_erase_event(map_action,event)
	InputMap.action_add_event(action, event)
	# And then save it to the keymaps file
	KeyPersistence.keymaps[action] = InputMap.get_action_list(action)
	KeyPersistence.save_keymap()
	text = "%s Key" % event.as_text()


func display_current_key():
	var current_key
	for list_entry in InputMap.get_action_list(action):
		if list_entry is InputEventKey:
			current_key = list_entry.as_text()
	text = "%s Key" % current_key