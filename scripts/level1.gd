extends Node2D

onready var player = $Player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var blocks_gone = false
onready var fake_blocks = $FakeBlocks/AnimationPlayer
onready var camera = $Player/Camera2D
onready var to_level2_lower = $ToLevel2Lower
onready var to_level2_upper = $ToLevel2Upper
onready var to_level3 = $ToLevel3
# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	if player.global_position.y > 720:
		player.pivot.scale.x = -1
	Fade.level_enter()
	to_level2_lower.connect("body_entered",self,"_on_body_entered1")
	to_level2_upper.connect("body_entered",self,"_on_body_entered2")
	to_level3.connect("body_entered",self,"_on_body_entered3")
	camera.limit_right = 1232
	player.this_scene = "res://scenes/level1.tscn"
	if not(blocks_gone):
		camera.limit_bottom = 796
	
func _process(delta):
	if player.global_position.y > 700:
		camera.limit_bottom = 10000000
		if not(blocks_gone):
			fake_blocks.play("fade_out")
			blocks_gone = true
		

func _on_body_entered1(body:Node):
	Game.change_scene("res://scenes//level2.tscn",Vector2(88,525))

func _on_body_entered2(body:Node):
	Game.change_scene("res://scenes//level2.tscn",Vector2(75,75))

func _on_body_entered3(body:Node):
	Game.change_scene("res://scenes//level3.tscn",Vector2(1550,175))
