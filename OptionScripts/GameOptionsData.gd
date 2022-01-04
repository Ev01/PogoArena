extends Resource
class_name GameOptionsData

var is_fullscreen := false setget _set_fullscreen
var is_vsync := false setget _set_vsync

func _set_fullscreen(value):
	is_fullscreen = value
	OS.window_fullscreen = is_fullscreen


func _set_vsync(value):
	is_vsync = value
	OS.set_use_vsync(is_vsync)
	print(OS.vsync_enabled)
