extends Node2D

export (PackedScene) var menu_scn
export (PackedScene) var game_scn

var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	change_scene_to(menu_scn)


func change_scene_to(scene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene.instance()
	add_child(current_scene)


func load_new_game(player_count):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = game_scn.instance()
	current_scene.player_count = player_count
	add_child(current_scene)
	
