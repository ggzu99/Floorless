extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pause_menu = $PauseMenu
onready var options_menu = $OptionsMenu
onready var controls_menu = $ControlsMenu
onready var ui_elements = [options_menu,pause_menu,controls_menu]
onready var active_menu: MarginContainer = pause_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect("options_pressed",self, "_on_options_pressed")
	options_menu.connect("back_press",self,"_on_options_back_pressed")
	options_menu.connect("controls_press",self,"_on_controls_pressed")
	controls_menu.connect("return_press",self, "_on_controls_return_pressed")
	options_menu.hide()
	controls_menu.hide()
	visible = true
	
func _input(event):
	if event.is_action_pressed("pause"):
		if (!pause_menu.visible):
			if active_menu!=pause_menu: _on_menu_change(active_menu,pause_menu)
			pause_menu.show()
			active_menu = pause_menu
			pause_menu.resume.grab_focus()
			get_tree().paused = true
		else:
			active_menu.focus_holder.release_focus()
			pause_menu.hide()
			get_tree().paused = false

func _on_options_pressed():
	_on_menu_change(pause_menu,options_menu)

func _on_options_back_pressed():
	_on_menu_change(options_menu,pause_menu)

func _on_controls_pressed():
	_on_menu_change(options_menu,controls_menu)

func _on_controls_return_pressed():
	_on_menu_change(controls_menu,options_menu)

func _on_menu_change(from: MarginContainer, to: MarginContainer):
	to.show()
	to.focus_holder.grab_focus()
	active_menu = to
	from.hide()
	from.focus_holder.release_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
