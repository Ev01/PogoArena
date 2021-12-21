extends HBoxContainer

export (Array, String) var control_scheme1
export (Array, String) var control_scheme2
export (Array, String) var control_scheme3

# The index of the next unjoined PlayerJoinPanel, also equal to the amount of players joined
var active_panel_num = 0
var taken_controls = []

# The colour corresponding to each control scheme
var colours = [Color.yellow, Color.green, Color.red]
# Player number corresponding to each control scheme
var player_nums = [3, 1, 2]
# Player name corresponding to each control scheme
var player_names = ["Yellow", "Green", "Red"]
onready var control_schemes = [control_scheme1,  control_scheme2, control_scheme3]
# This list will rearange as the join panels rearrange themselves when unjoining
onready var join_panels = get_children()
# This list stays the same
onready var join_panels_org = get_children()
onready var main = get_node("/root/Main")
onready var audio_manager = get_node("/root/Main/AudioManager")

func _ready():
	for p in range(len(join_panels_org)):
		join_panels[p].remove_btn.connect("pressed", self, "_on_panel_remove_pressed", [p])
	
	# If Main's player data isnt empty, use it. This is what remembers what players were joined.
	if main.player_data:
		set_player_data(main.player_data)


func get_player_data():
	var player_count = 0
	var players = []
	for panel in join_panels:
		if panel.joined:
			player_count += 1
			var panel_data = {
				colour = panel.colour,
				controls = panel.control,
				player_num = panel.player_num,
				player_name = panel.player_name,
			}
			players.append(panel_data)
		
	return {
		player_count = player_count,
		players = players
	}


func set_player_data(data : Dictionary):
	# First unjoin every panel
	for panel_num in range(len(join_panels_org)):
		if join_panels_org[panel_num].joined:
			_on_panel_remove_pressed(panel_num)
	# Then join the panels back with our new player_data
	for player in data.players:
		join_panels[active_panel_num].join(player.controls, player.colour, player.player_num, player.player_name)
		taken_controls.append(player.controls)
		active_panel_num += 1
	

func _input(event):
	# Loop through all control schemes
	for s in len(control_schemes):
		# If the control scheme is taken, skip it
		if control_schemes[s] in taken_controls:
				continue
		for control in control_schemes[s]:
			if Input.is_action_just_pressed(control):
				# Check if there is an empty join_panel
				if active_panel_num < len(join_panels):
					join_panels[active_panel_num].join(control_schemes[s], colours[s], player_nums[s], player_names[s])
					taken_controls.append(control_schemes[s])
					active_panel_num += 1
					audio_manager.play_sound("res://Player/pogoready.wav", 1+(float(active_panel_num-1)/2), -5)


func _on_panel_remove_pressed(panel_num):
	var to_remove = join_panels_org[panel_num]
	taken_controls.erase(to_remove.control)
	to_remove.unjoin()
	print("yello")
	active_panel_num -= 1
	print(active_panel_num)
	
	move_child(to_remove, len(join_panels)-1)
	join_panels = get_children()
	#join_panels.remove(panel_num)
	#join_panels.append(to_remove)
