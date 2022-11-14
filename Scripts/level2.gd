extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var to_level1_lower = $ToLevel1Lower
onready var to_level1_upper = $ToLevel1Upper

# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	Fade.level_enter()
	to_level1_lower.connect("body_entered",self,"_on_body_entered1")
	to_level1_upper.connect("body_entered",self,"_on_body_entered2")
	player.this_scene = "res://scenes/level2.tscn"

func _on_body_entered1(_body:Node):
	Game.change_scene("res://scenes/level1.tscn",Vector2(1100,824))

func _on_body_entered2(_body:Node):
	Game.change_scene("res://scenes/level1.tscn",Vector2(1104,80))
