tool
extends Label

var screen_size: Vector2

func _ready():
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	# Make sure rect is at its minimum size
	rect_size.x = 0
	update_size()



func update_size():
	screen_size = get_viewport_rect().size
	rect_position.x = screen_size.x/2 - rect_size.x/2


func _on_screen_resized():
	update_size()
