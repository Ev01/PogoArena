class_name Sound
extends AudioStreamPlayer



onready var tween = Tween.new()
onready var default_volume = volume_db
onready var volume_linear = db2linear(default_volume) setget _set_volume_linear

func _ready():
	add_child(tween)


func fade_in(duration: float):
	tween.interpolate_property(self, "volume_linear", 0, 
		db2linear(default_volume), duration * Engine.time_scale)
	tween.start()
	play()


func fade_out(duration: float):
	tween.interpolate_property(self, "volume_linear", db2linear(volume_db), 
		0, duration * Engine.time_scale)
	tween.start()
	yield(tween, "tween_all_completed")
	stop()


func _set_volume_linear(value):
	volume_linear = value
	volume_db = linear2db(volume_linear)
