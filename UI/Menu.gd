extends Control

export (NodePath) var player_join_path
export (NodePath) var match_settings_path

onready var player_join = get_node(player_join_path)
onready var main = get_node("/root/Main")
onready var match_settings = get_node(match_settings_path)


func _on_PlayButton_pressed():
	var player_data = player_join.get_player_data()
	main.load_new_game(player_data)


func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			grab_focus()
