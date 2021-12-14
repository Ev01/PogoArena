extends Area2D

class_name RespawnPoint

func is_spawnable():
	if len(get_overlapping_bodies()) > 0:
		return false
	
	return true
