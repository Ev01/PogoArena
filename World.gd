extends Node2D


export (PackedScene) var player1_scn
export (PackedScene) var player2_scn
export (PackedScene) var player3_scn

onready var player1_spawns = get_tree().get_nodes_in_group("Player1Spawn")
onready var player2_spawns = get_tree().get_nodes_in_group("Player2Spawn")
onready var player3_spawns = get_tree().get_nodes_in_group("Player3Spawn")

onready var spawns = [player1_spawns, player2_spawns, player3_spawns]

onready var main = get_node("/root/Main")
var player_count = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_players()


func add_player(player_scene):
	var new_player = player_scene.instance()
	add_child(new_player)
	new_player.respawn()


func spawn_players():
	if player_count >= 1:
		add_player(player1_scn)
	
	if player_count >= 2:
		add_player(player2_scn)
	
	if player_count >= 3:
		add_player(player3_scn)


func choose_spawn(player_num):
	var final_spawn
	for spawn in spawns[player_num - 1]:
		final_spawn = spawn.position
		if spawn.is_spawnable():
			break
	
	return final_spawn
	

func _input(event):
	if Input.is_action_just_pressed("Reset"):
		main.load_new_game()
