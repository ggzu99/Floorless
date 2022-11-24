extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var anim_player = $AnimationPlayer
signal activated
# Called when the node enters the scene tree for the first time.


func activate():
	anim_player.play("fade")
	yield(anim_player,"animation_finished")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
