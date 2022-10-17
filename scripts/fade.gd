extends CanvasLayer

onready var animation_player = $AnimationPlayer

signal fade_in
signal fade_out

func _ready():
	animation_player.connect("animation_finished",self,"_on_animation_finished")

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func _on_animation_finished(anim_name: String):
	if anim_name == "fade_in":
		emit_signal("fade_in")
	if anim_name == "fade_out":
		emit_signal("fade_out")

func to_level(scene_name:String):
	fade_in()
	yield(Fade,"fade_in")
	get_tree().change_scene(scene_name)

func level_enter():
	fade_out()
	yield(Fade,"fade_out")
