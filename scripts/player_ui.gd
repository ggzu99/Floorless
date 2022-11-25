extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pause_menu = $PauseMenu
onready var options_menu = $OptionsMenu
onready var ui_elements = [options_menu,pause_menu]
var focus_holder: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.resume.connect("pressed", pause_menu, "_on_resume_pressed")
	pause_menu.options.connect("pressed", pause_menu, "_on_options_pressed")
	pause_menu.main_menu.connect("pressed", pause_menu, "_on_main_menu_pressed")
	pause_menu.exit.connect("pressed", pause_menu, "_on_exit_pressed")
	pause_menu.connect("release_focus", self, "_on_pause_changed")
	options_menu.controls.connect("pressed", options_menu, "_on_controls_pressed")
	options_menu.connect("back_press",self,"_on_options_back_pressed")
	visible = true
	
func _input(event):
	if event.is_action_pressed("pause"):
		var is_ui_displaying_elements = false
		for ui_element in ui_elements:
			if ui_element!=pause_menu:
				is_ui_displaying_elements |= ui_element.visible
		if (!is_ui_displaying_elements):
			pause_menu.visible = !pause_menu.visible
			if (pause_menu.visible):
				focus_holder = pause_menu.resume
				pause_menu.resume.grab_focus()
			else:
				focus_holder = null
				pause_menu.resume.release_focus()
			get_tree().paused = pause_menu.visible
		else:
			focus_holder.release_focus()
			pause_menu.resume.grab_focus()
			focus_holder = pause_menu.resume

func _on_options_back_pressed():
	options_menu.visible = false
	options_menu.sound.release_focus()
	pause_menu.visible = true
	pause_menu.resume.grab_focus()
	
func _on_pause_changed(change_to: String):
	if change_to == "resume":
		pause_menu.resume.release_focus()
	elif change_to == "options":
		pause_menu.resume.release_focus()
		options_menu.sound.grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
