extends Node2D

var emitting = false setget _set_emitting
var children = []

func _ready():
	children = get_children()


func _process(delta):
	var should_kill = true
	for child in children:
		if child.emitting == true:
			should_kill = false
			break
	
	if should_kill:
		queue_free()


func _set_emitting(value):
	for child in children:
		child.emitting = value
