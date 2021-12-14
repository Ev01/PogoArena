extends Area2D


func is_spawnable():
	if len(get_overlapping_bodies()) > 0:
		return false
	
	return true
