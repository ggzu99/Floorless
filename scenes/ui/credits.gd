extends MarginContainer

var credits = [
	{
		"name": "m6x11",
		"author": "https://managore.itch.io/"
	},
	{
		"name": "Bat Sprites",
		"author": "https://rentro-ghost.itch.io/"
	},
	{
		"name": "Spikes",
		"author": "https://omniclause.itch.io/"
	},
	{
		"name": "Rogue Knight",
		"author": "https://darkpixel-kronovi.itch.io/"
	},
	{
		"name": "Tile set and BG pack - 16x16 Tilesets",
		"author": "https://biganon-1.itch.io/"
	}
]

var staff = [
	{
		"name":"Jesus Echeverria",
		"page":"https://ggzu.itch.io/"
	},
	{
		"name":"Nicolas Escobar",
		"page":"https://tchy.itch.io/"
	},
	{
		"name":"Lucas Brule",
		"page":"https://deftness01.itch.io/"
	}
]

var spthanks = [
	{
		"name": "Elixs",
		"page": "https://akaipengin.itch.io/"
	},
	{
		"name":"Puntitowo",
		"page":"https://puntitowo.itch.io/"
	}
]
var scroll_speed = 1
var scroll_ended = false

onready var credits_container = $ScrollContainer/CreditsContainer
onready var asset_container = $ScrollContainer/CreditsContainer/Assets
onready var staff_container = $ScrollContainer/CreditsContainer/Staff
onready var spthanks_container = $ScrollContainer/CreditsContainer/SpecialThanks
onready var scroll_container = $ScrollContainer
onready var disclaimer = $ScrollContainer/CreditsContainer/Disclaimer

func _ready():
	Fade.level_enter()
	disclaimer.visible = false
	_insert_assets()
	_insert_staff()
	_insert_spthanks()
	scroll_container.scroll_vertical = 0
	set_physics_process(false)
	yield(get_tree().create_timer(1), "timeout")
	set_physics_process(true)


func _physics_process(delta):
	if !scroll_ended:
		if Input.is_action_pressed("ui_accept"):
			scroll_speed=4
		else:
			scroll_speed=1
	var last_scroll = scroll_container.scroll_vertical
	scroll_container.scroll_vertical += scroll_speed
	var new_scroll = scroll_container.scroll_vertical
	if new_scroll == last_scroll:
		_try_end_scroll()

func _create_separator() -> HSeparator:
	var h_separator = HSeparator.new()
	h_separator.theme_type_variation = "SmallHSeparator"
	return h_separator

func _create_label(text) -> Label:
	var label = Label.new()
	label.align = Label.ALIGN_CENTER
	label.autowrap = true
	label.text = text
	return label

func _insert_assets():
	for credit in credits:
		var name_label = _create_label(credit.name)
		var author_label = _create_label(credit.author)
		asset_container.add_child(_create_separator())
		asset_container.add_child(name_label)
		asset_container.add_child(author_label)

func _try_end_scroll():
	if not scroll_ended:
		scroll_ended = true
		yield(get_tree().create_timer(2), "timeout")
		disclaimer.visible = true
		scroll_speed = 9999
		yield(get_tree().create_timer(0.25),"timeout")
		Fade.to_level("res://scenes/ui/main_menu.tscn")
		
func _insert_staff():
	for credit in staff:
		var name_label = _create_label(credit.name)
		var page_label = _create_label(credit.page)
		staff_container.add_child(_create_separator())
		staff_container.add_child(name_label)
		staff_container.add_child(page_label)

func _insert_spthanks():
	for credit in spthanks:
		var name_label = _create_label(credit.name)
		var page_label = _create_label(credit.page)
		spthanks_container.add_child(_create_separator())
		spthanks_container.add_child(name_label)
		spthanks_container.add_child(page_label)
	spthanks_container.add_child(_create_separator())
	spthanks_container.add_child(_create_label("Equipo Docente SpA"))
	
	
