extends Node2D

signal transition_finished()

export (PackedScene) var menu_scn
export (PackedScene) var game_scn
export (NodePath) var transition_path

var current_scene
var player_data

onready var game_options = GameOptionsData.new()
onready var match_settings = MatchSettingsData.new()
onready var transition = get_node(transition_path)
onready var audio_manager = $AudioManager

# Called when the node enters the scene tree for the first time.
func _ready():
	change_scene_to(menu_scn, false)


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
		yield(transition, "fade_out_finished")
	emit_signal("transition_finished")


func load_new_game(p_player_data):
	get_tree().paused = false
	#match_settings = p_match_settings
	player_data = p_player_data
	transition.fade_in()
	yield(transition, "fade_in_finished")
	
	if current_scene:
		# queue_free will make get_nodes_in_group get deleted spawns
		current_scene.call_deferred("free") 
	
	current_scene = game_scn.instance()
	#current_scene.player_data = player_data
	#current_scene.max_score = match_settings.max_score
	
	#current_scene.match_settings = match_settings
	call_deferred("add_child", current_scene)
	
	transition.fade_out()
	yield(transition, "fade_out_finished")
	emit_signal("transition_finished")
	
