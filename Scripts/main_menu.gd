extends MarginContainer

onready var play = $VBoxContainer/Play
onready var credits = $VBoxContainer/Credits
onready var exit = $VBoxContainer/Exit
onready var options = $VBoxContainer/Options
onready var focus_holder = play

signal options_pressed

func _ready():
	play.connect("pressed", self, "_on_play_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _on_play_pressed():
	Fade.to_level("res://scenes/tutorial.tscn")

func _on_options_pressed():
	emit_signal("options_pressed")

func _on_credits_pressed():
	Fade.to_level("res://scenes/ui/credits.tscn")

func _on_exit_pressed():
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
