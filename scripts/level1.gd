extends Node2D

onready var player = $Player/Player_Character
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var blocks_gone = false
onready var fake_blocks = $FakeBlocks/AnimationPlayer
onready var camera = $Player/Player_Character/Camera2D
onready var to_level2 = $ToLevel2
# Called when the node enters the scene tree for the first time.
func _ready():
	player.global_position = Game.player_position
	if player.global_position.y > 720:
		player.pivot.scale.x = -1
	Fade.level_enter()
	to_level2.connect("body_entered",self,"_on_body_entered")
	camera.limit_right = 1120
	player.this_scene = "res://scenes/level1.tscn"
	if not(blocks_gone):
		camera.limit_bottom = 796
	
func _process(delta):
	if player.global_position.y > 700:
		camera.limit_bottom = 10000000
		if not(blocks_gone):
			fake_blocks.play("fade_out")
			blocks_gone = true
		

func _on_body_entered(body:Node):
	Game.change_scene("res://scenes//level2.tscn",Vector2(88,525))
