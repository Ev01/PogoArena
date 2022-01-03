extends Resource
class_name GameOptionsData

var is_fullscreen := false setget _set_fullscreen


func _set_fullscreen(value):
	is_fullscreen = value
	OS.window_fullscreen = is_fullscreen
