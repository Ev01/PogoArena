extends Label


# Declare member variables here. Examples:
# var a = 2
onready var timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a-=delta/timer.wait_time


func _on_Timer_timeout():
	queue_free()
