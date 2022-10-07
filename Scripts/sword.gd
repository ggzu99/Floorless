extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_parent().get_parent()
onready var ray_cast = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(4)
	if body.collision_layer & 2:
		player.bounce(body.global_position)
		player.can_dash=true
	if body.collision_layer & 8:
		player.bounce(ray_cast.get_collision_point())
	
	

func _physics_process(delta):
	if ray_cast.is_colliding():
		if ray_cast.get_collider().collision_layer & 8:
			player.bounce(ray_cast.get_collision_point())
