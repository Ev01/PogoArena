tool
extends Button


export (Resource) var skin_data setget _set_skin_data

onready var skin_icon = $Icon


func _ready():
	update_skin()


func update_skin():
	if skin_icon:
		skin_icon.texture = skin_data.texture


func _set_skin_data(value):
	skin_data = value
	update_skin()
