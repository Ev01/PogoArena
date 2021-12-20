extends Node2D


var current_map


func load_level(level_name : String):
	var file_path = "res://Maps/" + level_name + ".tscn"
	assert(File.new().file_exists(file_path), "The file " + file_path + " does not exist")
	if current_map:
		current_map.queue_free()
	
	var level_scn = load(file_path)
	
	current_map = level_scn.instance()
	add_child(current_map)
