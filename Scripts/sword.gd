extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_parent().get_parent()
onready var sword_hbox = $SwordHbox
onready var knockback = $KnockbackTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		player.hook_uses = 3
		body.take_damage(4)
	if knockback.is_stopped():
		knockback.start(0.6)
		if body.collision_layer & 2:
			player.turn_timer.start(0.1)
			player.bounce(body.global_position)
			player.can_dash=true
		if body.collision_layer & 8:
			var hbox = self.global_position
			if player.pivot.rotation_degrees==0:
				player.turn_timer.start(0.1)
				if player.pivot.scale.x==1:
					hbox.x+=25
				else:
					hbox.x-=25
			else:
				if player.up_pressed:
					hbox.y-=25
				elif player.down_pressed:
					hbox.y+=25
			var tilemap_pos = body.map_to_world(hbox)
			var tile_pos = body.world_to_map(tilemap_pos)
			player.bounce(tile_pos)
