extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var return_button = $VBoxContainer/Return
onready var focus_holder = return_button
signal return_press

onready var button_containers = $VBoxContainer/MappingContainer/HBoxContainer4/ButtonContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	return_button.connect("pressed",self,"_on_return_pressed")
	for button_container in button_containers.get_children():
		for input_remap_button in button_container.get_children():
			input_remap_button.connect("input_changed",self,"_on_input_changed")
	

func _on_return_pressed():
	emit_signal("return_press")


func _on_input_changed(button: Button):
	button.grab_focus()
	for button_container in button_containers.get_children():
		for input_remap_button in button_container.get_children():
			input_remap_button.display_current_key()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
