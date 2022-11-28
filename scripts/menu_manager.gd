extends CanvasLayer

onready var menu_container = $MenuContainer
onready var options_menu = $OptionsMenu
onready var controls_menu = $ControlsMenu
onready var ui_controls_menu = $UiControlsMenu
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	menu_container.show()
	menu_container.connect("options_pressed",self,"_on_options_pressed")
	menu_container.focus_holder.grab_focus()
	options_menu.connect("back_press",self,"_on_options_back_pressed")
	options_menu.connect("controls_press",self,"_on_options_controls_pressed")
	controls_menu.connect("return_press",self, "_on_controls_return_pressed")
	controls_menu.connect("change_press",self, "_on_controls_change_pressed")
	ui_controls_menu.connect("change_press",self, "_on_ui_controls_change_pressed")
	ui_controls_menu.connect("return_press",self,"_on_ui_controls_return_pressed")
	options_menu.hide()
	controls_menu.hide()
	ui_controls_menu.hide()
	Fade.level_enter()


func _on_options_pressed():
	_on_menu_change(menu_container,options_menu)
	
func _on_options_back_pressed():
	_on_menu_change(options_menu,menu_container)
	
func _on_options_controls_pressed():
	_on_menu_change(options_menu,controls_menu)

func _on_controls_change_pressed():
	_on_menu_change(controls_menu,ui_controls_menu)

func _on_ui_controls_change_pressed():
	_on_menu_change(ui_controls_menu,controls_menu)

func _on_controls_return_pressed():
	_on_menu_change(controls_menu,options_menu)
	
func _on_ui_controls_return_pressed():
	_on_menu_change(ui_controls_menu,options_menu)

func _on_menu_change(from: MarginContainer, to: MarginContainer):
	to.show()
	to.focus_holder.grab_focus()
	from.hide()
	from.focus_holder.release_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
