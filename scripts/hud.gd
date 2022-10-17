extends MarginContainer

onready var hearts = $HBoxContainer/HP
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lives = 6 setget set_lives
onready var animation_player = $PowerUpDisplay/AnimationPlayer
onready var label = $PowerUpDisplay/PowerUpName
# Called when the node enters the scene tree for the first time.
func _ready():
	lives = Game.player_lives
	hearts.frame=6-lives

func set_lives(value):
	lives=value
	if lives==0:
		pass
		#Morirse
	else:
		hearts.frame=6-lives
	Game.player_lives=lives


func power_up_obtained(name:String):
	label.text = name+" obtained!"
	animation_player.play("visible")
	yield(get_tree().create_timer(2),"timeout")
	animation_player.play("not_visible")
