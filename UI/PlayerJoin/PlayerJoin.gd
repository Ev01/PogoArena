extends Control

signal active_panel_changed

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

onready var hbox = $HBoxContainer
onready var press_to_join_lbl = $PressToJoin
# This list will rearange as the join panels rearrange themselves when unjoining
onready var join_panels = hbox.get_children()
# This list stays the same
onready var join_panels_org = hbox.get_children()
onready var main = get_node("/root/Main")
onready var audio_manager = get_node("/root/Main/AudioManager")

func _ready():
	for p in range(len(join_panels_org)):
		join_panels[p].remove_btn.connect("pressed", self, "_on_panel_remove_pressed", [p])
	
	# If Main's player data isnt empty, use it. This is what remembers what players were joined.
	if main.player_data:
		set_player_data(main.player_data)
	
	connect("active_panel_changed", self, "_on_active_panel_changed")
	emit_signal("active_panel_changed")


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
	emit_signal("active_panel_changed")

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
					emit_signal("active_panel_changed")
					audio_manager.play_sound("res://Player/pogoready.wav", 1+(float(active_panel_num-1)/2), -5)


func _on_panel_remove_pressed(panel_num):
	var to_remove = join_panels_org[panel_num]
	taken_controls.erase(to_remove.control)
	to_remove.unjoin()
	active_panel_num -= 1
	emit_signal("active_panel_changed")
	hbox.move_child(to_remove, len(join_panels)-1)
	join_panels = hbox.get_children()
	#join_panels.remove(panel_num)
	#join_panels.append(to_remove)


func _on_active_panel_changed():
	var press_to_join_txt = ""
	var non_taken_controls = []
	for control in control_schemes:
		if not control in taken_controls:
			non_taken_controls.append(control)
	# Loop through all non_taken controls and put them in a string
	for i in range(len(non_taken_controls)):
		for c in non_taken_controls[i]:
			
			press_to_join_txt += " "
			# Get the first key in an action
			press_to_join_txt += InputMap.get_action_list(c)[0].as_text()
		if i == len(non_taken_controls) - 2:
			# Put an or instead of a comma if this is the last item in the list
			# "Press A D, Left Right or J L to join"
			press_to_join_txt += " or "
		elif i != len(non_taken_controls) - 1:
			# put a comma at the end if this isnt the last or second last item
			press_to_join_txt += ", "
	
	# If all controls are taken, dont show anything
	if press_to_join_txt:
		press_to_join_lbl.text = "Press %s to join." % press_to_join_txt
	else:
		press_to_join_lbl.text = ""
