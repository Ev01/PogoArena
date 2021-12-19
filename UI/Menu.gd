extends Control


#onready var player_num_button = $PlayersOption/PlayerNumButton
onready var player_join = $PlayerJoin
onready var main = get_node("/root/Main")
onready var match_settings = $PanelContainer/ScrollContainer/MatchSettings





func _on_PlayButton_pressed():
	var player_data = player_join.get_player_data()
	main.load_new_game(player_data, match_settings.settings)


func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			grab_focus()
