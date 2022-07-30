extends Node2D

var emitting = false setget _set_emitting
var children = []
var vel = Vector2.ZERO

func _ready():
	children = get_children()


func _process(delta):
	var should_kill = true
	for child in children:
		if child.get_class() == "CPUParticles2D":
			if child.emitting == true:
				should_kill = false
				break
	
	if should_kill:
		queue_free()
	
	vel -= (vel * 5) * delta
	position += vel*delta


func _set_emitting(value):
	for child in children:
		if child.get_class() == "CPUParticles2D":
			child.emitting = value
