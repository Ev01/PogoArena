extends Control

class_name MatchSetting

export (String) var setting_name = "Setting"
export (NodePath) var match_settings_path
export (NodePath) var value_node_path = "ValueChange"

onready var match_settings = get_node(match_settings_path)
onready var value_node = get_node(value_node_path)


func _ready():
	#value_node.connect("value_changed", self, "_on_value_changed")
	match_settings.settings[setting_name] = value_node.value


#func _on_value_changed(value):
#	match_settings.settings[setting_name] = value
