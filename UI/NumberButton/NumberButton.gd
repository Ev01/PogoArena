tool
extends Control

export var min_value = 0
export var max_value = 4
export var value = 0 setget _set_value

onready var value_label = $Value

signal value_changed(value)

func _ready():
	_set_value(value)


func _on_Up_pressed():
	if not Engine.is_editor_hint():
		self.value = clamp(value + 1, min_value, max_value)


func _on_Down_pressed():
	if not Engine.is_editor_hint():
		self.value = clamp(value - 1, min_value, max_value)


func _set_value(val):
	value = clamp(val, min_value, max_value)
	emit_signal("value_changed", value)
	if value_label:
		value_label.text = str(value)
		print(str(value))


func _on_Value_text_changed(new_text):
	pass


func _on_Value_text_entered(new_text):
	value_label.release_focus()


func _on_Value_focus_exited():
	if not Engine.is_editor_hint:
		var caret_position = value_label.caret_position
		self.value = int(value_label.text)
		value_label.caret_position = caret_position
