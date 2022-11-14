extends KinematicBody2D


const GRAVITY = 10
const SPEED = 200
const JUMP_SPEED = 280
const ACCELERATION = 2000
const HOOK_PULL = 20

enum State {
	NORMAL,
	DASHING,
	HOOK_ACTIVE,
	HOOKED
}

var color_time_count = 0.0
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
var iframes = false
var can_air_jump = true

signal do_charge_slash

onready var pivot = $Pivot
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/playback")
onready var sprite = $Pivot/Sprite
onready var dmg_timer = $DamageTimer
onready var dash_timer = $DashTimer
onready var sword = $Pivot/Sword
onready var charge_timer = $Pivot/Sword/ChargeTimer
onready var charge_startup = $Pivot/Sword/ChargeStartup
onready var hud = $PlayerUI/HUD
onready var turn_timer = $TurnaroundTimer
onready var hook = $Hook
onready var line = $Hook/Links
onready var hook_tip = $Hook/Tip
onready var gun = $Pivot/Gun
onready var wall_particles = $Pivot/WallParticles
onready var charge_particles = $Pivot/ChargeParticles
onready var charge_particles_material = $Pivot/ChargeParticles.process_material
onready var modulate_tween = $Pivot/Sprite/ModulateTween
onready var charge_particle_tween = $Pivot/ChargeParticles/ChargeTween
export(bool) var movement_enabled = true
export(bool) var slash1 = false
export(bool) var slash2 = false
export(bool) var slash3 = false
export(bool) var charge_slash = false
export(bool) var direction_modifier = false
export(bool) var is_charging = false
export(PackedScene) var hook_particles_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	playback.travel("fall")
	hook.connect("hooked",self,"_on_hooked")
	charge_startup.connect("timeout",self,"_on_charge_startup")
	charge_timer.connect("timeout",self,"_on_charge_complete")
	

#Function that takes inputs
func _input(event):
	if event.is_action_pressed("jump"):
		wall_jump()
		air_jump()
	if event.is_action_pressed("dash") and dash_timer.is_stopped() and can_dash:
		playback.travel("dash")
		can_dash=false
		dash(last_dir)
	if movement_enabled and dash_timer.is_stopped():
		if event.is_action_pressed("slash"):
			slash()
			if Game.charge_slash: charge_startup.start(1)
			if down_pressed or up_pressed: direction_modifier=true
		if event.is_action_released("slash") and is_charging:
			is_charging = false
			charge_startup.stop()
			if charge_timer.is_stopped() and Game.charge_slash:
				charge_slash = true
				charge_particles.emitting = false
				emit_signal("do_charge_slash")
				charge_particles_material.emission_ring_radius = 0.01
				charge_particles_material.emission_ring_inner_radius = 0
				charge_particles_material.color = Color(0,0,0,1)
	if event.is_action_pressed("hook") and hook_uses>0:
		hook_uses-=1
		if horizontal_input!=0 and vertical_input!=0:
			hook.shoot(Vector2(horizontal_input,vertical_input*3/8))
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
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		if self.global_position.distance_to(hook.tip) > 18 and state!=State.HOOKED:
			state=State.HOOK_ACTIVE
			hook_velocity = to_local(hook.tip).normalized() * HOOK_PULL
			if hook_velocity.y > 0:
				# Pulling down isn't as strong
				hook_velocity.y *= 0.7
			else:
				# Pulling up is stronger
				hook_velocity.y *= 1.5
			if sign(hook_velocity.x) != sign(horizontal_input):
				# if we are trying to walk in a different
				# direction than the hook is pulling
				# reduce its pull
				hook_velocity.x *= 0.7
		else:
			state=State.HOOKED
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
	if !Input.is_action_pressed("slash"):
		charge_startup.stop()
		is_charging = false
		charge_timer.stop()
	if dash_timer.is_stopped() and state==State.DASHING:
		state=State.NORMAL
	if state==State.DASHING:
		velocity.x=move_toward(velocity.x,dash_direction * SPEED *1.5,ACCELERATION)
	elif state==State.NORMAL and turn_timer.is_stopped():
		velocity.x=move_toward(velocity.x,horizontal_input * SPEED,ACCELERATION)
	#Taking damage
	if dmg_timer.get_time_left()>0:
		self.collision_mask=0b1101
		if iframes:
			sprite.self_modulate.a = 0
			iframes = !iframes
		else:
			iframes = !iframes
			sprite.self_modulate.a = 1
	if dmg_timer.get_time_left()==0:
		sprite.self_modulate.a = 1
		iframes = false
		self.collision_mask=0b1111
	if !is_charging and !charge_slash:
		charge_particles.emitting = false
		charge_particles_material.emission_ring_radius = 0.01
		charge_particles_material.emission_ring_inner_radius = 0
		sprite.self_modulate.r = 1
		sprite.self_modulate.g = 1
		sprite.self_modulate.b = 1
		charge_particles_material.color = Color(0,0,0,1)
	if velocity.y < 180 and (state!=State.DASHING or state!=State.HOOKED):
		velocity.y += GRAVITY
	if not direction_modifier: pivot.rotation_degrees = 0.0
	for i in get_slide_count():
		collisions.append(get_slide_collision(i))
		if dmg_timer.get_time_left()==0:
			#Collide with spikes
			if collisions[i].collider.collision_layer & 8:
				take_damage(2)
				bounce(collisions[i].position,true)
			#Collide with enemies
			if collisions[i].collider.collision_layer & 2:
				take_damage(2)
				bounce(collisions[i].position)
	#Animations
	var real_wall = wall_and_not_enemy(collisions)
	if is_on_wall() and real_wall and state==State.NORMAL:
		hook_uses = 3
		can_air_jump = true
		if velocity.y>0:
			if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
				can_dash=true
				pivot.scale.x=-1
				velocity.y = 100
				if dash_timer.is_stopped(): 
					playback.travel("wall_slide")
					wall_particles.emitting = true
			elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				can_dash=true
				pivot.scale.x=1
				velocity.y = 100
				if dash_timer.is_stopped(): 
					playback.travel("wall_slide")
					wall_particles.emitting = true
			else:
				wall_particles.emitting = false
				pivot.scale.x=last_dir
				if dash_timer.is_stopped(): playback.travel("fall")
	else:
		wall_particles.emitting = false
	if not (is_on_wall()) or state==State.HOOKED:
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
	if charge_slash:
		playback.travel("charge_slash")
	gun.visible = hook.visible
	gun.rotation = line.rotation - deg2rad(90)
	if state==State.HOOKED:
		velocity = Vector2(0,0)

func wall_jump():
	if is_on_wall() and movement_enabled:
		if last_dir<0:
			velocity.x = JUMP_SPEED
		elif last_dir>0:
			velocity.x = -JUMP_SPEED
		velocity.y = -JUMP_SPEED
		turn_timer.start(0.04)

func air_jump():
	if Game.air_jump and can_air_jump and not(is_on_wall()):
		can_air_jump = false
		velocity.y = -JUMP_SPEED*1.2

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
	iframes = true
	is_charging = false
	charge_timer.stop()

func wall_and_not_enemy(collisions):
	for collision in collisions:
		if collision.collider.collision_layer & 2:
			return false
	return true

func get_powerup(name:String):
	hud.power_up_obtained(name)

func _on_hooked():
	var hook_particles = hook_particles_scene.instance()
	get_parent().add_child(hook_particles)
	hook_particles.global_position = hook_tip.global_position
	hook_particles.rotation = hook_tip.rotation

func _on_charge_startup():
	charge_timer.start(1)
	is_charging = true
	charge_particles.emitting = true
	charge_particle_tween.interpolate_property(charge_particles_material,"emission_ring_radius",charge_particles_material.emission_ring_radius,50,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	charge_particle_tween.interpolate_property(charge_particles_material,"emission_ring_inner_radius",charge_particles_material.emission_ring_inner_radius,20,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	charge_particle_tween.interpolate_property(charge_particles_material,"color",charge_particles_material.color,Color8(255,255,255,255),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	charge_particle_tween.start()
	modulate_tween.interpolate_property(sprite,"self_modulate",sprite.self_modulate,Color8(255,217,115,sprite.self_modulate.a8),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	modulate_tween.start()

func _on_charge_complete():
	charge_particles_material.color = Color8(255,217,115,255)
