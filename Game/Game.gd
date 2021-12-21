extends Node2D


export (PackedScene) var player_scn
export (PackedScene) var score_label_scn

var player1_spawns# = get_tree().get_nodes_in_group("Player1Spawn")
var player2_spawns# = get_tree().get_nodes_in_group("Player2Spawn")
var player3_spawns# = get_tree().get_nodes_in_group("Player3Spawn")
var spawns# = [player1_spawns, player2_spawns, player3_spawns]

var is_game_finished = false
#var player_data
#var match_settings = {}
#var player_count = 2
var players = []
var time_label

onready var main = get_node("/root/Main")
onready var world = $World
onready var score_container = $UI/Scores
onready var win_popup = $UI/WinDialog
onready var game_timer = $TimeLeft


# Called when the node enters the scene tree for the first time.
func _ready():
	#match_settings = main.match_settings
	#player_data = main.player_data
	world.load_level(main.match_settings.settings.map)
	# The countdown timer is part of the map so it can be moved around based on the map layout
	time_label = world.current_map.get_node("TimeLbl")
	
	player1_spawns = get_tree().get_nodes_in_group("Player1Spawn")
	assert(player1_spawns, "No player 1 spawns in level, make sure to add the Player1Spawn group")
	player2_spawns = get_tree().get_nodes_in_group("Player2Spawn")
	assert(player2_spawns, "No player 2 spawns in level, make sure to add the Player2Spawn group")
	player3_spawns = get_tree().get_nodes_in_group("Player3Spawn")
	assert(player3_spawns, "No player 3 spawns in level, make sure to add the Player3Spawn group")
	
	spawns = [player1_spawns, player2_spawns, player3_spawns]
	
	spawn_players()
	update_match_settings()
	#_set_time_left(match_settings.time)
	game_timer.connect("timeout", self, "_on_game_timer_timeout")
	game_timer.start(main.match_settings.settings.time)


func _process(delta):
	if time_label:
		time_label.text = str(int(game_timer.time_left))


func add_player(data, player_num):
	
	var new_player = player_scn.instance()
	players.append(new_player)
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
	for p in range(len(main.player_data.players)):
		add_player(main.player_data.players[p], p + 1)


func update_match_settings():
	for p in players:
		p.respawn_time = main.match_settings.settings.respawn_time
		p.gravity_multiplier = main.match_settings.settings.gravity_multiplier
		p.bounce_power = main.match_settings.settings.bounce_power


func choose_spawn(player_num):
	var final_spawn
	for spawn in spawns[player_num - 1]:
		final_spawn = spawn.position
		if spawn.is_spawnable():
			break
	
	return final_spawn


func get_highest_scoring():
	# Check which player finished with the highest score
	# Returns a list with the winner, or multiple players if there is a tie.
	var highest_scoring = []
	for p in players:
		if not highest_scoring:
			highest_scoring = [p]
		elif p.current_score == highest_scoring[0].current_score:
			# There will be multiple winners if there is a tie
			highest_scoring.append(p)
		elif p.current_score > highest_scoring[0].current_score:
			highest_scoring = [p]
	
	return highest_scoring


func win_game(winning_players : Array, reason = ""):
	# Reason is something like "Match aborted." or "Time out!"
	# Win message says who wins, e.g. "Green wins" or "Tie between Green and Red"
	var win_message = ""
	
	win_popup.popup()
	#get_tree().paused = true
	Engine.time_scale = 0.1
	is_game_finished = true
	
	if len(winning_players) == 1:
		win_message = "%s Wins!" % winning_players[0].player_name
	elif len(winning_players) > 1:
		win_message = "Tie between "
		for p in range(len(winning_players)):
			# If this is the last listed player
			if p == len(winning_players) - 1:
				win_message += " and %s" % winning_players[p].player_name
			# If this is the first listed player
			elif p == 0:
				win_message += "%s" % winning_players[p].player_name
			else:
				win_message += ", %s" % winning_players[p].player_name
		
	win_popup.window_title = reason + " " + win_message


func abort_game():
	# TODO: This can be replaced with win_game
	win_game(get_highest_scoring(), "Match Aborted.")


func _input(event):
	if Input.is_action_just_pressed("Reset"):
		main.load_new_game()


func _on_player_score_changed(current_score, player):
	if current_score >= main.match_settings.settings.max_score:
		# Wait a very small amount of time before winning the game in case two players died 
		# at the same time (technically just a very small amount of time apart)
		yield(get_tree().create_timer(0.04), "timeout")
		# Need to call get_highest_scoring here in case there is a tie
		win_game(get_highest_scoring())


func _on_player_got_kill(player):
	if not is_game_finished:
		player.current_score += 1


func _on_player_killed_self(player):
	player.current_score = max(player.current_score - 1 , 0)


func _on_game_timer_timeout():
	win_game(get_highest_scoring(), "Time out!")
