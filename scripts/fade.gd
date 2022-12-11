extends CanvasLayer

onready var animation_player = $AnimationPlayer
onready var animation_player2 = $PowerUpDisplay/AnimationPlayer
onready var label: Label = $PowerUpDisplay/PowerUpName
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
	get_tree().paused = true
	get_tree().change_scene(scene_name)
	get_tree().paused = false

func level_enter():
	fade_out()
	get_tree().paused = true
	yield(Fade,"fade_out")
	get_tree().paused = false

func power_up_obtained(name:String, desc:String):
	label.text = name+" obtained!"
	animation_player2.play("visible")
	yield(get_tree().create_timer(3),"timeout")
	animation_player2.play("not_visible")
	label.text = desc
	animation_player2.play("visible")
	yield(get_tree().create_timer(4),"timeout")
	animation_player2.play("not_visible")

func display_msg(msg:String):
	label.text = msg
	animation_player2.play("visible")
	yield(get_tree().create_timer(3),"timeout")
	animation_player2.play("not_visible")
