extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 100
var velocity = Vector2()
var moves_left=true
var ACCELERATION = 2000

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/playback")
onready var flip_time=$FlipTimer
onready var pivot=$Pivot
onready var hp=12
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	flip_time.start(0.5) # Replace with function body.
	playback.travel("movement")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y=0
	velocity = move_and_slide(velocity,Vector2.UP)
	playback.travel("movement")
	if flip_time.is_stopped():
		flip_time.start(0.5)
		moves_left=!moves_left
	if moves_left:
		pivot.scale.x=1
	else:
		pivot.scale.x=-1
	velocity.x=-pivot.scale.x*SPEED
	if hp<=0:
		queue_free()

func take_damage(damage):
	playback.travel("damage")
	hp-=damage
