extends MarginContainer

onready var hearts = $HBoxContainer/HP
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lives = 6 setget set_lives

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = Game.player_lives

func set_lives(value):
	lives=value
	if lives==0:
		pass
		#Morirse
	else:
		hearts.frame=6-lives
	Game.player_lives=lives
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
