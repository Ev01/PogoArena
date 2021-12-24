extends Control


onready var play_again_btn = $MarginContainer/Control/HBoxContainer/PlayAgain
onready var menu_btn = $MarginContainer/Control/HBoxContainer/BackToMenu
onready var game = get_node("/root/Main/Game")
onready var main = get_node("/root/Main")
onready var label_title = $MarginContainer/Control/Label

func _ready():
	hide()
	play_again_btn.connect("pressed", self, "_on_play_again_pressed")
	menu_btn.connect("pressed", self, "_on_menu_pressed")


func _on_play_again_pressed():
	Engine.time_scale = 1
	main.audio_manager.stop_music(0.8)
	main.load_new_game(main.player_data)


func _on_menu_pressed():
	Engine.time_scale = 1
	main.audio_manager.stop_music(0.8)
	main.change_scene_to(main.menu_scn)
