extends Control


onready var player_num_button = $PlayersOption/PlayerNumButton
onready var main = get_node("/root/Main")

func _on_PlayButton_pressed():
	main.load_new_game(player_num_button.current_value)




func _on_Control_gui_input(event):
	print("df")
	if event is InputEventMouseButton:
		if event.pressed == true:
			grab_focus()
			print("afsdasdf")
