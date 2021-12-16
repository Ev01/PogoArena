extends Particles2D

func _process(delta):
	if emitting == false:
		queue_free()
