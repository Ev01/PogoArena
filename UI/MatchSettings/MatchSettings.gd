extends Control

onready var vbox = $VBoxContainer

# TODO: this script should get the values from each setting and change the settings variable
# accordingly, the setting nodes should not change the settings variable.

# Settings set by MatchSetting class
# key: String setting_name, value: setting_value
# var settings = {} setget _set_settings, _get_settings

# Dictionary of setting names and the nodes that set them
# key: String setting_name, value: Node setting_node
var setting_nodes = {}

onready var main = get_node("/root/Main")


func _ready():
	#main.match_settings.connect
	
	# Register each setting name to its coresponding setting node
	for setting_node in vbox.get_children():
		if setting_node.get_class() != "Control":
			continue
		setting_nodes[setting_node.setting_name] = setting_node
	
	# After registering each node, set each setting in the dictionary to each nodes current value
	#update_settings_dict()
	
	#print("Setting nodes ", setting_nodes)
	
	#print("Main's settings: ", main.match_settings)
	
	#if main.match_settings:
		# If main's settings have been set, use those instead
	#	_set_settings(main.match_settings)
	#	print('yes')
	
	
	#print("Match Settings: ", settings)
	#print("Match settings: ", settings)
	

"""
func update_settings_dict():
	## This function will loop through all of the setting nodes and update the settings dictionary.
	var setting_names = setting_nodes.keys()
	# Loop through all setting nodes
	for i in range(len(setting_names)):
		# The setting value is assigned to the setting node's value
		main.match_settings.set_setting(setting_names[i], setting_nodes[setting_names[i]].value_node.value)
	
	print("Settings updated, now equal to ", main.match_settings.settings)
"""
"""
func _set_settings(value):
	print()
	print("Set settings called!")
	print()
	# Set our dictionary
	settings = value
	# Set Main's settings dictionary
	main.match_settings = value
	var setting_names = setting_nodes.keys()
	# Loop through all setting nodes
	for i in range(len(setting_names)):
		# Set the nodes value to the dictionary's value
		print("Node ", setting_nodes[setting_names[i]].name, "'s value being set to ", settings[setting_names[i]])
		setting_nodes[setting_names[i]].value_node.value = settings[setting_names[i]]
	
	update_settings_dict()
"""
"""
func _get_settings():
	#update_settings_dict()
	return settings
"""
