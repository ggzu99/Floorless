extends KinematicBody2D


const GRAVITY = 10
const SPEED = 200
const JUMP_SPEED = 280
const ACCELERATION = 2000
const HOOK_PULL = 20

enum State {
	NORMAL,
	DASHING,
	HOOK_ACTIVE
}

var state = State.NORMAL
var velocity = Vector2()
var hook_velocity = Vector2(0,0)
var can_dash = true
var dash_direction = 1
var down_pressed = false
var up_pressed = false
var hook_uses = 3
var horizontal_input
var vertical_input
var last_dir=1
var this_scene:String

onready var pivot = $Pivot
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/playback")
onready var sprite = $Pivot/Sprite
onready var dmg_timer = $DamageTimer
onready var dash_timer = $DashTimer
onready var hud = $PlayerUI/HUD
onready var turn_timer = $TurnaroundTimer
onready var hook = $Hook
onready var line = $Hook/Links
onready var gun = $Pivot/Gun
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
		wall_jump()
	if event.is_action_pressed("dash") and dash_timer.is_stopped() and can_dash:
		playback.travel("dash")
		can_dash=false
		dash(last_dir)
	if movement_enabled and dash_timer.is_stopped():
		if event.is_action_pressed("slash") and (down_pressed or up_pressed):
			slash()
			direction_modifier=true
		elif event.is_action_pressed("slash"):
			slash()
	if event.is_action_pressed("hook") and hook_uses>0:
		hook_uses-=1
		if horizontal_input!=0 and vertical_input!=0:
			hook.shoot(Vector2(horizontal_input,vertical_input/4))
		elif horizontal_input==0 and vertical_input!=0:
			hook.shoot(Vector2(0,vertical_input))
		else:
			hook.shoot(Vector2(last_dir,vertical_input))
	if event.is_action_released("hook"):
		hook.release()
		state = State.NORMAL
			
		
			
func _physics_process(delta):
	var collisions = []
	if state==State.DASHING:
		velocity.y=0
	velocity = move_and_slide(velocity,Vector2.UP,true)
	if hook.hooked:
		state=State.HOOK_ACTIVE
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		hook_velocity = to_local(hook.tip).normalized() * HOOK_PULL
		if hook_velocity.y > 0:
			# Pulling down isn't as strong
			hook_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			hook_velocity.y *= 1.25
		if sign(hook_velocity.x) != sign(horizontal_input):
			# if we are trying to walk in a different
			# direction than the hook is pulling
			# reduce its pull
			hook_velocity.x *= 0.7
	else:
		# Not hooked -> no hook velocity
		hook_velocity = Vector2(0,0)
	velocity += hook_velocity

	horizontal_input = Input.get_axis("move_left","move_right")
	if horizontal_input!=0:
		last_dir=horizontal_input
	vertical_input = Input.get_axis("move_up","move_down")
	if vertical_input==1:
		down_pressed=true
	else:
		down_pressed=false
	if vertical_input==-1:
		up_pressed=true
	else:
		up_pressed=false
	if dash_timer.is_stopped() and state==State.DASHING:
		state=State.NORMAL
	if state==State.DASHING:
		velocity.x=move_toward(velocity.x,dash_direction * SPEED *1.5,ACCELERATION)
	elif state==State.NORMAL and turn_timer.is_stopped():
		velocity.x=move_toward(velocity.x,horizontal_input * SPEED,ACCELERATION)
	#Taking damage
	if dmg_timer.get_time_left()>0:
		self.collision_mask=0b1101
		if sprite.get_self_modulate()==Color(1,1,1,1):
			sprite.set_self_modulate(Color(1,1,1,0))
		else:
			sprite.set_self_modulate(Color(1,1,1,1))
	if dmg_timer.get_time_left()==0:
		sprite.set_self_modulate(Color(1,1,1,1))
		self.collision_mask=0b1111
	if velocity.y < 180 and state!=State.DASHING:
		velocity.y += GRAVITY
	if not direction_modifier: pivot.rotation_degrees = 0.0
	for i in get_slide_count():
		collisions.append(get_slide_collision(i))
		if dmg_timer.get_time_left()==0:
			#Collide with spikes
			if collisions[i].collider.collision_layer & 8:
				take_damage(1)
				bounce(collisions[i].position,true)
			#Collide with enemies
			if collisions[i].collider.collision_layer & 2:
				take_damage(2)
				bounce(collisions[i].position)
	#Animations
	var real_wall = wall_and_not_enemy(collisions)
	if is_on_wall() and real_wall and state==State.NORMAL:
		hook_uses = 3
		if velocity.y>0:
			if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
				can_dash=true
				pivot.scale.x=-1
				velocity.y = 100
				if dash_timer.is_stopped(): playback.travel("wall_slide")
			elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				can_dash=true
				pivot.scale.x=1
				velocity.y = 100
				if dash_timer.is_stopped(): playback.travel("wall_slide")
			else:
				pivot.scale.x=last_dir
				if dash_timer.is_stopped(): playback.travel("fall")
				
	if not (is_on_wall()):
		if Input.is_action_pressed("move_left") and not (Input.is_action_pressed("move_right")) and dash_timer.is_stopped():
			pivot.scale.x=-1
		if Input.is_action_pressed("move_right") and not (Input.is_action_pressed("move_left")) and dash_timer.is_stopped():
			pivot.scale.x=1
		if velocity.y>0:
			if state!=State.DASHING: playback.travel("fall")
	if velocity.y<0:
		if state!=State.DASHING: playback.travel("jump")
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
	gun.visible = hook.visible
	gun.rotation = line.rotation - deg2rad(90)

func wall_jump():
	if is_on_wall() and movement_enabled:
		if last_dir<0:
			velocity.x = JUMP_SPEED
		elif last_dir>0:
			velocity.x = -JUMP_SPEED
		velocity.y = -JUMP_SPEED
		turn_timer.start(0.04)
	

func dash(direction):
	dash_direction=direction
	pivot.scale.y=1
	velocity.x=0
	state = State.DASHING
	dash_timer.start(0.5)

func slash():
	if not slash1 and not slash2 and not slash3:
			slash1=true
	if slash1 and not slash2 and not slash3:
			slash2=true
	if not slash1 and slash2 and not slash3:
			slash3=true

func bounce(origin:Vector2,with_floor=false):
	var mult=1.5
	var direction = (global_position - origin).normalized()
	if with_floor:
		mult=1.2
	velocity = direction * SPEED * mult

func take_damage(value):
	hud.lives-=value
	if hud.lives<=0:
		hud.lives=Game.default_lives
		get_tree().change_scene(this_scene)
	dmg_timer.start(1)

func wall_and_not_enemy(collisions):
	for collision in collisions:
		if collision.collider.collision_layer & 2:
			return false
	return true
