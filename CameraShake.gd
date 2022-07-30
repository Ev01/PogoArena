extends Camera2D

# Declare member variables here. Examples:
var is_shaking = false
var shake
var fade_out
onready var shake_timer = $ShakeTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_shaking:
		shake = max(shake-(delta*fade_out)/shake_timer.wait_time,0)
		set_offset(Vector2(rand_range(-shake, shake), rand_range(-shake, shake)))
	else:
		set_offset(Vector2(0, 0))
	
	if shake_timer.is_stopped():
		is_shaking = false

func camera_shake(shake_amount,duration):
	is_shaking = true
	shake = shake_amount
	fade_out = shake_amount
	shake_timer.wait_time = duration
	shake_timer.start()
