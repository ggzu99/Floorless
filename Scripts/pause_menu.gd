extends MarginContainer

onready var resume = $VBoxContainer/Resume
onready var main_menu = $VBoxContainer/MainMenu
onready var options = $VBoxContainer/Options
onready var exit = $VBoxContainer/Exit
signal release_focus


func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	main_menu.connect("pressed", self, "_on_main_menu_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	visible=false


func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	emit_signal("release_focus", "resume")

func _on_options_pressed():
	visible = false
	emit_signal("release_focus", "options")

func _on_main_menu_pressed():
	Game.reset_defaults()
	Fade.to_level("res://scenes/ui/main_menu.tscn")
	emit_signal("release_focus", "main_menu")
	#get_tree().paused = false

func _on_exit_pressed():
	get_tree().quit()
