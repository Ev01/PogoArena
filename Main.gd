extends Node2D

export (PackedScene) var menu_scn
export (PackedScene) var game_scn

var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	change_scene_to(menu_scn)


func change_scene_to(scene):
	get_tree().paused = false
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene.instance()
	add_child(current_scene)


func load_new_game(player_data, max_score):
	get_tree().paused = false
	if current_scene:
		# queue_free will make get_nodes_in_group get deleted spawns
		current_scene.call_deferred("free") 
	
	current_scene = game_scn.instance()
	current_scene.player_data = player_data
	current_scene.max_score = max_score
	call_deferred("add_child", current_scene)
	
