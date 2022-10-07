extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hud = $HUD
onready var pause_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.visible = !visible
		get_tree().paused = pause_menu.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
