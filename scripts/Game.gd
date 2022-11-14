extends Node

var default_lives = 6
var player_lives = 6
var player_position = Vector2(116,162)
var air_jump = false
var charge_slash = false

func change_scene(scene:String, new_player_pos:Vector2):
	Fade.to_level(scene)
	player_position = new_player_pos

func reset_defaults():
	player_lives = default_lives
	air_jump = false
	charge_slash = false
