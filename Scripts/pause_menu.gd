extends MarginContainer

onready var resume = $VBoxContainer/Resume
onready var main_menu = $VBoxContainer/MainMenu
onready var exit = $VBoxContainer/Exit


func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	main_menu.connect("pressed", self, "_on_main_menu_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	visible=false


func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_main_menu_pressed():
	Game.reset_defaults()
	Fade.to_level("res://scenes/ui/main_menu.tscn")
	#get_tree().paused = false

func _on_exit_pressed():
	get_tree().quit()
