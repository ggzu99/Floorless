extends MarginContainer

onready var resume = $VBoxContainer/Resume
onready var main_menu = $VBoxContainer/MainMenu
onready var options = $VBoxContainer/Options
onready var exit = $VBoxContainer/Exit
signal options_pressed
onready var focus_holder: Button = resume

func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	main_menu.connect("pressed", self, "_on_main_menu_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	visible=false


func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	focus_holder = resume

func _on_options_pressed():
	visible = false
	focus_holder = options
	emit_signal("options_pressed")

func _on_main_menu_pressed():
	Game.reset_defaults()
	Fade.to_level("res://scenes/ui/main_menu.tscn")
	focus_holder = main_menu

func _on_exit_pressed():
	get_tree().quit()
