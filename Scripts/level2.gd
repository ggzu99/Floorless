extends Node2D

onready var player = $Player/Player_Character
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.this_scene = "res://scenes/level2.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
