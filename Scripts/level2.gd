extends Node2D

onready var player = $Player/Player_Character
onready var camera = $Player/Player_Character/Camera2D
onready var to_level1 = $ToLevel1

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	Fade.level_enter()
	to_level1.connect("body_entered",self,"_on_body_entered")
	player.this_scene = "res://scenes/level2.tscn"

func _on_body_entered(_body:Node):
	Game.change_scene("res://scenes/level1.tscn",Vector2(976,824))
