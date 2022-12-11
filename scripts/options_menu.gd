extends MarginContainer

onready var controls = $VBoxContainer/Controls
onready var sound = $VBoxContainer/Sound
onready var back = $VBoxContainer/Back
onready var fullscreen = $VBoxContainer/CheckBox
onready var focus_holder: Button = fullscreen
signal back_press
signal controls_press
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	fullscreen.connect("toggled",self, "_on_fullscreen_toggle")
	if OS.window_fullscreen: fullscreen.pressed = true
	controls.connect("pressed", self, "_on_controls_pressed")
	sound.connect("pressed", self, "_on_sound_pressed")
	back.connect("pressed", self, "_on_back_pressed")
	sound.disabled = !Game.easter_egg
	if !sound.disabled:
		sound.text = "Secret"


func _on_fullscreen_toggle(button_pressed: bool):
	OS.window_fullscreen = button_pressed
	
func _on_sound_pressed():
	Fade.display_msg("Thank you for playing!")
	yield(get_tree().create_timer(4),"timeout")
	Fade.display_msg("This game actually has no sound, sorry :(")
	yield(get_tree().create_timer(4),"timeout")
	Fade.display_msg("I hope you enjoyed it regardless :)")

func _on_controls_pressed():
	emit_signal("controls_press")
	
func _on_back_pressed():
	emit_signal("back_press")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
