extends Node2D

export (PackedScene) var menu_scn
export (PackedScene) var game_scn
export (NodePath) var transition_path

var current_scene

onready var transition = get_node(transition_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	change_scene_to(menu_scn, false)


#func change_scene_to_coroutine(scene):
#	# See https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#coroutines-with-yield
#	get_tree().paused = false
#	if current_scene:
#		# queue_free will make get_nodes_in_group get deleted spawns when loading new game
#		current_scene.call_deferred("free") 
#	current_scene = scene.instance()
#	
#	yield()
#	
#	add_child(current_scene)


func change_scene_to(scene, do_transition = true):
	get_tree().paused = false
	if do_transition:
		transition.fade_in()
		yield(transition, "fade_in_finished")
		
	if current_scene:
		# queue_free will make get_nodes_in_group get deleted spawns when loading new game
		current_scene.call_deferred("free") 
	current_scene = scene.instance()
	add_child(current_scene)
	
	if do_transition:
		transition.fade_out()

#func change_scene_to_transition(scene):
#	
#	var co = change_scene_to_coroutine(scene)
#	transition.fade_in()
#	yield(transition, "fade_in_finished")
#	co.resume()
#	transition.fade_out()


func load_new_game(player_data, match_settings):
	get_tree().paused = false
	transition.fade_in()
	yield(transition, "fade_in_finished")
	
	if current_scene:
		# queue_free will make get_nodes_in_group get deleted spawns
		current_scene.call_deferred("free") 
	
	current_scene = game_scn.instance()
	current_scene.player_data = player_data
	#current_scene.max_score = match_settings.max_score
	current_scene.match_settings = match_settings
	call_deferred("add_child", current_scene)
	
	transition.fade_out()
	
