extends LineEdit


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.position):
			release_focus()
