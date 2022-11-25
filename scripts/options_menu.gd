extends MarginContainer

onready var controls = $VBoxContainer/Controls
onready var sound = $VBoxContainer/Sound
onready var back = $VBoxContainer/Back

signal back_press
signal controls_press
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	controls.connect("pressed", self, "_on_controls_pressed")
	sound.connect("pressed", self, "_on_sound_pressed")
	back.connect("pressed", self, emit_signal("back_press"))

func _on_sound_pressed():
	print("Not implemented")

func _on_controls_pressed():
	emit_signal("controls_press")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
