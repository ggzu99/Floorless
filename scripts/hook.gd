"""
This script controls the hook.
"""
extends Node2D
onready var links = $Links		# A slightly easier reference to the links
onready var length_timer = $LengthTimer
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.

const SPEED = 8.5	# The speed with which the chain moves
signal hooked
var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	length_timer.start(0.45)
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position

# release() the chain
func release() -> void:
	flying = false	# Not flying anymore	
	hooked = false	# Not attached anymore

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	if flying: $Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip
	if hooked:
		links.frame=1
	else:
		links.frame=0

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		if length_timer.get_time_left() > 0:
			var collision_shape = $Tip.move_and_collide(direction * SPEED)
			if collision_shape:
				if collision_shape.collider.collision_layer & 4:
					hooked = true	# Got something!
					emit_signal("hooked")
					flying = false	# Not flying anymore
				else:
					release()
		else:
			release()
	tip = $Tip.global_position	# set `tip` as starting position for next frame
