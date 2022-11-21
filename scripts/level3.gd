extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var to_level1 = $ToLevel1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	Fade.level_enter()
	player.this_scene = "res://scenes/level3.tscn"
	to_level1.connect("body_entered",self,"_on_body_entered")
	pass # Replace with function body.


func _on_body_entered(body:Node):
	Game.change_scene("res://scenes/to_level1.tscn",Vector2(50,400))
