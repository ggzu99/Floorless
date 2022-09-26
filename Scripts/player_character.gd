extends KinematicBody2D


var GRAVITY = 10
var SPEED = 200
var JUMP_SPEED = 280
var ACCELERATION = 2000
var velocity = Vector2()
var can_dash = true
var down_pressed = false
var up_pressed = false

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
		if event.is_action_pressed("slash") and (down_pressed or up_pressed):
			slash()
			direction_modifier=true
		elif event.is_action_pressed("slash"):
			slash()
			
func _physics_process(delta):
	if dash_timer.get_time_left()>0:
		velocity.y=0
	velocity = move_and_slide(velocity,Vector2.UP,true)
	var horizontal_input = Input.get_axis("move_left","move_right")
	var vertical_input = Input.get_axis("move_up","move_down")
	if vertical_input==1:
		down_pressed=true
	else:
		down_pressed=false
	if vertical_input==-1:
		up_pressed=true
	else:
		up_pressed=false
	if !movement_enabled:
		horizontal_input=0
	if dash_timer.get_time_left()>0:
		velocity.x=move_toward(velocity.x,pivot.scale.x * SPEED *1.5,ACCELERATION)
	else:
		if playback.get_current_node()=="dash": playback.travel("dash_end")
		velocity.x = move_toward(velocity.x,horizontal_input * SPEED,ACCELERATION)
	#Taking damage
	if dmg_timer.get_time_left()>0:
		if sprite.get_self_modulate()==Color(1,1,1,1):
			sprite.set_self_modulate(Color(1,1,1,0))
		else:
			sprite.set_self_modulate(Color(1,1,1,1))
	if dmg_timer.get_time_left()==0:
		sprite.set_self_modulate(Color(1,1,1,1))
		
	if velocity.y < 150 and dash_timer.get_time_left()==0:
		velocity.y += GRAVITY
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get_name()=="Spikes" and dmg_timer.get_time_left()==0:
			take_damage()
			bounce(true)
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
		if not direction_modifier: pivot.rotation_degrees = 0.0
		pivot.scale.y=1
		if Input.is_action_pressed("move_left") and not (Input.is_action_pressed("move_right")) and dash_timer.is_stopped():
			pivot.scale.x=-1
		if Input.is_action_pressed("move_right") and not (Input.is_action_pressed("move_left")) and dash_timer.is_stopped():
			pivot.scale.x=1
		if velocity.y>0:
			if dash_timer.is_stopped(): playback.travel("fall")
		elif velocity.y<0:
			if dash_timer.is_stopped(): playback.travel("jump")
	if down_pressed and direction_modifier:
		if pivot.scale.x==1: pivot.rotation_degrees=90
		else: pivot.rotation_degrees=-90
	if up_pressed and direction_modifier:
		if pivot.scale.x==1: pivot.rotation_degrees=-90
		else: pivot.rotation_degrees=90
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

func bounce(with_floor=false):
	var mult=1.2
	if with_floor:
		mult=1.0
	if pivot.rotation_degrees==abs(90) or with_floor:
		velocity.y=move_toward(velocity.y,-pivot.scale.y*JUMP_SPEED*mult,ACCELERATION)
	else:
		velocity.x=move_toward(velocity.x,pivot.scale.x * SPEED *mult,ACCELERATION)

func take_damage():
	dmg_timer.start(1)
