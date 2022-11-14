extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wave_val = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if not(Game.charge_slash):
		connect("body_entered",self,"_on_body_entered")
	else:
		queue_free()

func _physics_process(delta):
	wave_val+=0.2
	if wave_val>=2*PI:
		wave_val-=2*PI
	global_position.y-=sin(wave_val)/2

func _on_body_entered(body:Node):
	Game.charge_slash = true
	body.get_powerup("ChargeSlash")
	queue_free()
