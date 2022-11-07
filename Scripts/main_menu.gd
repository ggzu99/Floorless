extends MarginContainer

onready var play = $VBoxContainer/Play
onready var credits = $VBoxContainer/Credits
onready var exit = $VBoxContainer/Exit


func _ready():
	Fade.level_enter()
	play.connect("pressed", self, "_on_play_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	play.grab_focus()
	exit.release_focus()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _on_play_pressed():
	Fade.to_level("res://scenes/tutorial.tscn")


func _on_credits_pressed():
	Fade.to_level("res://scenes/ui/credits.tscn")


func _on_exit_pressed():
	get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
