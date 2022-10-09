extends Node2D

onready var player = $Player/Player_Character
onready var camera = $Player/Player_Character/Camera2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.this_scene = "res://scenes/tutorial.tscn"
	camera.limit_right = 640
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.global_position.x >= 640:
		camera.limit_right = 0
		get_tree().change_scene("res://scenes/level1.tscn")
