extends Node2D

onready var egg = $EggArea
onready var map = $TileMap2 
onready var left = $Left
onready var bottom = $Bottom
onready var right = $Right
onready var player = $AnimationPlayer
var left_check = false
var bottom_check = false
var right_check = false
var vanished = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wave_val = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	egg.connect("body_entered",self,"_on_body_entered")
	left.connect("body_entered",self,"_on_left")
	bottom.connect("body_entered",self,"_on_bottom")
	right.connect("body_entered",self,"_on_right")

func _physics_process(delta):
	if left_check and right_check and bottom_check:
		if !vanished:
			vanished = true
			player.play("vanish")
			yield(player,"animation_finished")
			map.queue_free()
	wave_val+=0.2
	if wave_val>=2*PI:
		wave_val-=2*PI
	egg.global_position.y-=sin(wave_val)/2

func _on_left(body:Node):
	left_check = true

func _on_right(body:Node):
	right_check = true

func _on_bottom(body:Node):
	bottom_check = true

func _on_body_entered(body:Node):
	Game.easter_egg = true
	body.get_powerup("EasterEgg","Congrats!")
	egg.queue_free()
