extends Node

onready var options = get_node("/root/Main").game_options

func _ready():
	$CheckButton.value = options.is_fullscreen
	$CheckButton.connect("value_changed", self, "_on_CheckButton_value_changed")


func _on_CheckButton_value_changed(value):
	options.is_fullscreen = value
