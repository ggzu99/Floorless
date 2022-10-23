extends MarginContainer

var credits = [
	{
		"name": "m6x11",
		"author": "https://managore.itch.io"
	},
	{
		"name": "Bat Sprites",
		"author": "https://rentro-ghost.itch.io"
	},
	{
		"name": "Spikes",
		"author": "https://omniclause.itch.io"
	},
	{
		"name": "Rogue Knight",
		"author": "https://darkpixel-kronovi.itch.io"
	},
	{
		"name": "Tile set and BG pack - 16x16 Tilesets",
		"author": "https://biganon-1.itch.io"
	}
]

var scroll_speed = 1
var scroll_ended = false

onready var credits_container = $ScrollContainer/CreditsContainer
onready var scroll_container = $ScrollContainer


func _ready():
	Fade.level_enter()
	for credit in credits:
		var h_separator = HSeparator.new()
		h_separator.theme_type_variation = "SmallHSeparator"
		var name_label = _create_label(credit.name)
		var author_label = _create_label(credit.author)
		credits_container.add_child(h_separator)
		credits_container.add_child(name_label)
		credits_container.add_child(author_label)
	scroll_container.scroll_vertical = 0
	set_physics_process(false)
	yield(get_tree().create_timer(1), "timeout")
	set_physics_process(true)


func _physics_process(delta):
	var last_scroll = scroll_container.scroll_vertical
	scroll_container.scroll_vertical += scroll_speed
	var new_scroll = scroll_container.scroll_vertical
	if new_scroll == last_scroll:
		_try_end_scroll()


func _create_label(text) -> Label:
	var label = Label.new()
	label.align = Label.ALIGN_CENTER
	label.autowrap = true
	label.text = text
	return label

func _try_end_scroll():
	if not scroll_ended:
		scroll_ended = true
		yield(get_tree().create_timer(2), "timeout")
		get_tree().change_scene("res://scenes/ui/main_menu.tscn")
