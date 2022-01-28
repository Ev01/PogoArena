extends ParallaxLayer

var screen_size := Vector2(1024, 600)


func update_offset():
	# Set the offset to counteract the parallax offset bug
	motion_offset = -(screen_size / 2) + ((screen_size / 2) * motion_scale)

func _ready():
	update_offset()
