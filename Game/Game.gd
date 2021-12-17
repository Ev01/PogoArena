extends Node2D


export (PackedScene) var player_scn
export (PackedScene) var score_label_scn

var player1_spawns# = get_tree().get_nodes_in_group("Player1Spawn")
var player2_spawns# = get_tree().get_nodes_in_group("Player2Spawn")
var player3_spawns# = get_tree().get_nodes_in_group("Player3Spawn")

var spawns# = [player1_spawns, player2_spawns, player3_spawns]

var is_game_finished = false

onready var main = get_node("/root/Main")
onready var world = $World
onready var score_container = $UI/HBoxContainer
onready var win_popup = $UI/WinDialog

var player_data
#var player_count = 2
var max_score = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player1_spawns = get_tree().get_nodes_in_group("Player1Spawn")
	player2_spawns = get_tree().get_nodes_in_group("Player2Spawn")
	player3_spawns = get_tree().get_nodes_in_group("Player3Spawn")
	spawns = [player1_spawns, player2_spawns, player3_spawns]
	
	spawn_players()


func add_player(data, player_num):
	
	var new_player = player_scn.instance()
	world.add_child(new_player)
	new_player.connect("score_changed", self, "_on_player_score_changed", [new_player])
	new_player.connect("got_kill", self, "_on_player_got_kill", [new_player])
	new_player.connect("killed_self", self, "_on_player_killed_self", [new_player])
	
	new_player.modulate = data.colour
	new_player.player_num = data.player_num
	new_player.player_name = data.player_name
	new_player.action_rotate_left = data.controls[0]
	new_player.action_rotate_right = data.controls[1]
	
	new_player.respawn()
	
	var new_score_label = score_label_scn.instance()
	new_score_label.set_player(new_player)
	score_container.add_child(new_score_label)


func spawn_players():
	for p in range(len(player_data.players)):
		add_player(player_data.players[p], p+1)
	#if player_data.player_count >= 2:
	#	add_player(player2_scn)
	#if player_data.player_count >= 3:
	#	add_player(player3_scn)
	#if player_data.player_count >= 1:
	#	add_player(player1_scn)

	


func choose_spawn(player_num):
	var final_spawn
	for spawn in spawns[player_num - 1]:
		final_spawn = spawn.position
		if spawn.is_spawnable():
			break
	
	return final_spawn


func win_game(player):
	win_popup.popup()
	#get_tree().paused = true
	Engine.time_scale = 0.1
	is_game_finished = true
	win_popup.window_title = player.player_name + " Wins!"


func _input(event):
	if Input.is_action_just_pressed("Reset"):
		main.load_new_game()


func _on_player_score_changed(current_score, player):
	if current_score >= max_score:
		win_game(player)

func _on_player_got_kill(player):
	if not is_game_finished:
		player.current_score += 1


func _on_player_killed_self(player):
	player.current_score = max(player.current_score - 1 , 0)
