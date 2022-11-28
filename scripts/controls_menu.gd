extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var return_button = $VBoxContainer/Return
onready var focus_holder = return_button
signal return_press
# Called when the node enters the scene tree for the first time.
func _ready():
	return_button.connect("pressed",self,"_on_return_pressed")

func _on_return_pressed():
	emit_signal("return_press")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
