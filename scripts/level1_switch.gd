extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sprite_anim = $Switch/SwitchPlayer
onready var tile_anim = $Switch/TileMap2/TilePlayer
# Called when the node enters the scene tree for the first time.


func activate():
	sprite_anim.play("fade")
	tile_anim.play("fade")
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
