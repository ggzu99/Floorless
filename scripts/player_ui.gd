extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hud = $HUD
onready var pause_menu = $PauseMenu
onready var ui_elements = [hud,pause_menu]

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.resume.connect("pressed", pause_menu, "_on_resume_pressed")
	pause_menu.main_menu.connect("pressed", pause_menu, "_on_main_menu_pressed")
	pause_menu.exit.connect("pressed", pause_menu, "_on_exit_pressed")
	visible = true
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.visible = !pause_menu.visible
		get_tree().paused = pause_menu.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
