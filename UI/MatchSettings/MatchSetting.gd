extends Control

class_name MatchSetting

export (String) var setting_name = "setting"
export (NodePath) var match_settings_path
export (NodePath) var value_node_path = "ValueChange"

onready var match_settings = get_node(match_settings_path)
onready var value_node = get_node(value_node_path)
onready var main = get_node("/root/Main")


func _ready():
	value_node.connect("value_changed", self, "_on_value_changed")
	if value_node:
		if main.match_settings.get_setting(setting_name):
			value_node.value = main.match_settings.get_setting(setting_name)
		else:
			main.match_settings.set_setting(setting_name, value_node.value)
	else:
		printerr("Value node does not exist in match setting " + name)


func _on_value_changed(value):
	main.match_settings.set_setting(setting_name, value_node.value)
