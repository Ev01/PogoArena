extends Control

export var min_value = 0
export var max_value = 4
export var value = 0 setget _set_value

onready var value_label = $Value

func _on_Up_pressed():
	self.value = clamp(value + 1, min_value, max_value)


func _on_Down_pressed():
	self.value = clamp(value - 1, min_value, max_value)


func _set_value(val):
	value = val
	if value_label:
		value_label.text = str(val)
