extends KinematicBody2D


var GRAVITY = 10
var SPEED = 200
var JUMP_SPEED = 200
var ACCELERATION = 2000
var velocity = Vector2()
var can_dash = true


onready var pivot = $Pivot
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/playback")
onready var sprite = $Pivot/Sprite
onready var dmg_timer = $DamageTimer
onready var dash_timer = $DashTimer
#onready var sword = $Sword
#onready var sword_hitbox = $Sword/SwordHbox
export(bool) var movement_enabled = true
export(bool) var slash1 = false
export(bool) var slash2 = false
export(bool) var slash3 = false
export(bool) var direction_modifier = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	playback.travel("fall")

#Function that takes inputs
func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("dash") and dash_timer.is_stopped() and can_dash:
		playback.travel("dash")
		can_dash=false
		dash()
	if movement_enabled and dash_timer.is_stopped():
		if event.is_action_pressed("slash"):
			slash()
		elif event.is_action_pressed("down_slash"):
			slash()
			direction_modifier=true
			
func _physics_process(delta):
	if dash_timer.get_time_left()>0:
		velocity.y=0
	velocity = move_and_slide(velocity,Vector2.UP)
	var horizontal_input = Input.get_axis("move_left","move_right")
	var vertical_input = Input.get_axis("move_up","move_down")
	if !movement_enabled:
		horizontal_input=0
	if dash_timer.get_time_left()>0:
		velocity.x=move_toward(velocity.x,pivot.scale.x * SPEED *1.5,ACCELERATION)
	else:
		if playback.get_current_node()=="dash": playback.travel("dash_end")
		velocity.x = move_toward(velocity.x,horizontal_input * SPEED,ACCELERATION)
	#Taking damage
	if is_on_floor() and dmg_timer.get_time_left()==0:
		dmg_timer.start(1)
	if dmg_timer.get_time_left()>0:
		if sprite.get_self_modulate()==Color(1,1,1,1):
			sprite.set_self_modulate(Color(1,1,1,0))
		else:
			sprite.set_self_modulate(Color(1,1,1,1))
	if !is_on_floor() and dmg_timer.get_time_left()==0:
		sprite.set_self_modulate(Color(1,1,1,1))
		
	if velocity.y < 100 and dash_timer.get_time_left()==0:
		velocity.y += GRAVITY
		
	#if not sword_hitbox.is_disabled():
	#	sword.position
		
	#Animations
	if is_on_wall():
		can_dash=true
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			pivot.scale.y=-1
			pivot.rotation_degrees = 90
			if velocity.y>0:
				pivot.scale.x=1
			else:
				pivot.scale.x=-1
			if dash_timer.is_stopped(): playback.travel("run")
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			pivot.scale.y=-1
			pivot.scale.x=1
			pivot.rotation_degrees = -90
			if velocity.y>0:
				pivot.scale.x=-1
			if dash_timer.is_stopped(): playback.travel("run")
		else:
			if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				pivot.scale.y=1
				pivot.rotation_degrees=0
				if dash_timer.is_stopped(): playback.travel("fall")
	if not (is_on_wall()):
		if not direction_modifier: pivot.rotation_degrees = 0
		pivot.scale.y=1
		if Input.is_action_pressed("move_left") and not (Input.is_action_pressed("move_right")) and dash_timer.is_stopped():
			pivot.scale.x=-1
		if Input.is_action_pressed("move_right") and not (Input.is_action_pressed("move_left")) and dash_timer.is_stopped():
			pivot.scale.x=1
		if velocity.y>0:
			if dash_timer.is_stopped(): playback.travel("fall")
		elif velocity.y<0:
			if dash_timer.is_stopped(): playback.travel("jump")
	if direction_modifier:
		if pivot.scale.x==1: pivot.rotation_degrees=90
		else: pivot.rotation_degrees=-90
	if slash1:
		playback.travel("slash1")
	if slash2:
		playback.travel("slash2")
	if slash3:
		playback.travel("slash3")
	

func jump():
	if is_on_wall() and movement_enabled:
		velocity.y = -JUMP_SPEED
	

func dash():
	pivot.scale.y=1
	velocity.x=0
	dash_timer.start(0.5)

func slash():
	if not slash1 and not slash2 and not slash3:
			slash1=true
	if slash1 and not slash2 and not slash3:
			slash2=true
	if not slash1 and slash2 and not slash3:
			slash3=true
