extends KinematicBody2D


var GRAVITY = 10
var SPEED = 200
var JUMP_SPEED = 200
var ACCELERATION = 2000
var velocity = Vector2()

onready var pivot = $Pivot
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/playback")
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	playback.travel("fall")
	
func _physics_process(delta):
	velocity = move_and_slide(velocity,Vector2.UP)
	var horizontal_input = Input.get_axis("move_left","move_right")
	var vertical_input = Input.get_axis("move_up","move_down")
	velocity.x = move_toward(velocity.x,horizontal_input * SPEED,ACCELERATION)
	if velocity.y < 100:
		velocity.y += GRAVITY
	if is_on_wall() and Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_SPEED
	#Animations	
	if is_on_wall():
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			pivot.scale.y=-1
			pivot.rotation_degrees = 90
			if velocity.y>0:
				pivot.scale.x=1
			else:
				pivot.scale.x=-1
			playback.travel("run")
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			pivot.scale.y=-1
			pivot.scale.x=1
			pivot.rotation_degrees = -90
			if velocity.y>0:
				pivot.scale.x=-1
			playback.travel("run")
		else:
			if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				pivot.scale.y=1
				pivot.rotation_degrees=0
				playback.travel("fall")
	if not (is_on_wall()):
		pivot.rotation_degrees = 0
		pivot.scale.y=1
		if Input.is_action_pressed("move_left") and not (Input.is_action_pressed("move_right")):
			pivot.scale.x=-1
		if Input.is_action_pressed("move_right") and not (Input.is_action_pressed("move_left")):
			pivot.scale.x=1
		if velocity.y>0:
			playback.travel("fall")
		else:
			playback.travel("jump")
	if Input.is_action_pressed("slash"):
		playback.travel("wield_sword")
		playback.travel("slash1")
	if playback.get_current_node()=="slash1":
		playback.travel("sheathe_sword")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
