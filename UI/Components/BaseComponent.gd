extends Node

signal value_changed(value)

var value setget _set_value

func _ready():
	pass


func _set_value(val):
	value = val
	emit_signal("value_changed", value)
