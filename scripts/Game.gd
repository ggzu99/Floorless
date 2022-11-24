extends Node

var default_lives = 6
var player_lives = 6
# Lo de abajo devuelve un array con los nodos en el grupo player.
# En este caso el kinematic body del personaje en su escena es el único nodo en el grupo,
# por lo que está en la posición 0 del arreglo, luego se extrae la posición
# SOLO USAR PARA TESTING
# onready var player_position = get_tree().get_nodes_in_group("Player")[0].global_position
var player_position: Vector2
var player_direction: int
var air_jump = false
var charge_slash = false
var level3_switch_activated = false

func change_scene(scene:String, new_player_pos:Vector2, facing_direction: int):
	Fade.to_level(scene)
	player_direction = facing_direction
	player_position = new_player_pos

func reset_defaults():
	player_lives = default_lives
	air_jump = false
	charge_slash = false
