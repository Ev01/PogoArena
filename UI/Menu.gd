extends Control


onready var player_num_button = $PlayersOption/PlayerNumButton
onready var main = get_node("/root/Main")

func _on_PlayButton_pressed():
	main.load_new_game(player_num_button.current_value)
