extends "res://UI/Components/BaseComponent.gd"


func _ready():
	connect("toggled", self, "_on_button_toggled")


func _on_button_toggled(pressed):
	_set_value(pressed)


func _set_value(val):
	._set_value(val)
	set("pressed", val)
