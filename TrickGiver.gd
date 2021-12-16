extends Node2D


# Declare member variables here. Examples:
# var a = 2
export (PackedScene) var trick_text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func done_trick(text,pos):
	var trick_inst = trick_text.instance()
	add_child(trick_inst)
	trick_inst.rect_position=pos
	trick_inst.text=text
