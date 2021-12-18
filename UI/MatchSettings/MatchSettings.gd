extends Control

onready var vbox = $VBoxContainer

# TODO: this script should get the values from each setting and change the settings variable
# accordingly, the setting nodes should not change the settings variable.

# Settings set by MatchSetting class
# key: String setting_name, value: setting_value
var settings = {} setget _set_settings, _get_settings
# Dictionary of setting names and the nodes that set them
# key: String setting_name, value: Node setting_node
var setting_nodes = {}


func _ready():
	for setting_node in vbox.get_children():
		if setting_node.get_class() != "Control":
			continue
		setting_nodes[setting_node.setting_name] = setting_node


func update_settings():
	var setting_names = setting_nodes.keys()
	# Loop through all setting nodes
	for i in range(len(setting_names)):
		# The setting value is assigned to the setting node's value
		settings[setting_names[i]] = setting_nodes[setting_names[i]].get_node("ValueChange").value


func _set_settings(value):
	settings = value
	var setting_names = setting_nodes.keys()
	# Loop through all setting nodes
	for i in range(len(setting_names)):
		setting_nodes[setting_names[i]].get_node("ValueChange").value = settings[setting_names[i]]

func _get_settings():
	update_settings()
	return settings
