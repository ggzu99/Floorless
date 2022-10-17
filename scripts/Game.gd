extends Node

var default_lives = 6
var player_lives = 6
var player_position = Vector2(116,162)
var air_jump = false

func change_scene(scene:String, new_player_pos:Vector2):
	Fade.to_level(scene)
	player_position = new_player_pos
