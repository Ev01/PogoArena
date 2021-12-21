tool
extends VBoxContainer

export var min_value = 0
export var max_value = 4
export var default_value = 0 setget _set_default_value

signal value_changed(value)

onready var value = default_value setget _set_value
onready var slider = $HSlider
onready var line_edit = $LineEdit

func _ready():
	_set_value(default_value)
	slider.max_value = max_value
	slider.min_value = min_value
	
	print("value ", value)
	if not Engine.is_editor_hint():
		line_edit.connect("focus_exited", self, "_on_line_edit_focus_exited")
		line_edit.connect("text_entered", self, "_on_line_edit_text_entered")
		slider.connect("value_changed", self, "_on_slider_value_changed")
		


func _set_value(val):
	if slider:
		value = val
		value = float(val)
		slider.value = value
		
		# Change line edit
		var caret_position = line_edit.caret_position
		line_edit.text = str(value)
		line_edit.caret_position = caret_position
		
		emit_signal("value_changed", value)
		print("yay ", value)


func _set_default_value(val):
	default_value = val
	if Engine.is_editor_hint():
		self.value = default_value


func _on_line_edit_focus_exited():
	self.value = float(line_edit.text)
	print("exit")


func _on_line_edit_text_entered(new_text):
	line_edit.release_focus()


func _on_slider_value_changed(val):
	self.value = val
	
