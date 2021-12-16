extends HBoxContainer

export (Array, String) var control_scheme1
export (Array, String) var control_scheme2
export (Array, String) var control_scheme3

var active_panel_num = 0
var taken_controls = []

# The colour corresponding to each control scheme
var colours = [Color.yellow, Color.green, Color.red]
onready var control_schemes = [control_scheme1,  control_scheme2, control_scheme3]
# This list will rearange as the join panels rearrange themselves when unjoining
onready var join_panels = get_children()
# This list stays the same
onready var join_panels_org = get_children()

func _ready():
	for p in range(len(join_panels)):
		join_panels[p].remove_btn.connect("pressed", self, "_on_panel_remove_pressed", [p])


func get_player_data():
	var player_count = 0
	for panel in join_panels:
		if panel.joined:
			player_count += 1
		
		
	
	return {
		player_count = player_count
	}


func _input(event):
	for s in len(control_schemes):
		if control_schemes[s] in taken_controls:
				continue
		for control in control_schemes[s]:
			
			if Input.is_action_just_pressed(control):
				if active_panel_num < len(join_panels):
					join_panels[active_panel_num].join(control_schemes[s], colours[s])
					taken_controls.append(control_schemes[s])
					active_panel_num += 1
					print(active_panel_num)
				#if active_panel_num >= len(join_panels):
				#	active_panel_num = null


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
