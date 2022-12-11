extends MarginContainer

var hearts: Sprite
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lives = 6 setget set_lives

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = Game.player_lives
	hearts = $HBoxContainer/HP
	hearts.frame=6-lives

func set_lives(value):
	lives=value
	if lives==0:
		pass
		#Morirse
	else:
		hearts.frame=6-lives
	Game.player_lives=lives


