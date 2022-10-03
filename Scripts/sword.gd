extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(4)
	if body.collision_layer==2 or body.collision_layer==8:
		player.bounce(body)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
