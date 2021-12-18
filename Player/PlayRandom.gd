extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
export (Array, AudioStream) var sounds


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_random(pitch_min, pitch_max, vol_min = 0, vol_max = 0):
	pitch_scale=rand_range(pitch_min,pitch_max)
	volume_db=rand_range(vol_min,vol_max)
	stream = sounds[ randi() % len(sounds) ]
	play()
