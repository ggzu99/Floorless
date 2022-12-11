extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var to_level1 = $ToLevel1
onready var not_implemented = $NotImplemented
onready var light_switch = $LightSwitch
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	player.pivot.scale.x = Game.player_direction
	Fade.level_enter()
	player.this_scene = "res://scenes/level3.tscn"
	to_level1.connect("body_entered",self,"_on_body_entered")
	not_implemented.connect("body_entered",self,"_to_credits")
	light_switch.connect("activated",self,"_on_activated")
	if Game.level3_switch_activated:
		light_switch.queue_free()
	pass # Replace with function body.


func _on_body_entered(body:Node):
	Game.change_scene("res://scenes/level1.tscn",Vector2(50,400),1)

func _to_credits(body:Node):
	Game.reset_defaults()
	Fade.to_level("res://scenes/ui/credits.tscn")

func _on_activated():
	Game.level3_switch_activated = true
