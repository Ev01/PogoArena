extends Control

export (NodePath) var player_join_path
export (NodePath) var match_settings_path

onready var player_join = get_node(player_join_path)
onready var main = get_node("/root/Main")
onready var match_settings = get_node(match_settings_path)
onready var options_screen = $OptionsScreen
onready var play_button = get_node("RightSide/VBoxContainer/Buttons/PlayButton")

func _ready():
	options_screen.hide()
	main.audio_manager.play_existing("MenuMusic", 1)
	player_join.connect("active_panel_changed", self, "_on_active_panel_changed")
	_on_active_panel_changed()
	
	
func _on_PlayButton_pressed():
		var player_data = player_join.get_player_data()
		main.load_new_game(player_data)
		main.audio_manager.stop_existing("MenuMusic", 1)

func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			grab_focus()

func _on_active_panel_changed():
	play_button.disabled = not player_join.active_panel_num > 0


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	options_screen.show()


func _on_Options_BackBtn_pressed():
	options_screen.hide()
