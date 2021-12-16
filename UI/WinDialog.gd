extends WindowDialog


onready var play_again_btn = $PlayAgain
onready var menu_btn = $BackToMenu
onready var game = get_parent()
onready var main = get_node("/root/Main")

func _ready():
	play_again_btn.connect("pressed", self, "_on_play_again_pressed")
	menu_btn.connect("pressed", self, "_on_menu_pressed")


func _on_play_again_pressed():
	Engine.time_scale = 1
	main.load_new_game(game.player_count, game.max_score)


func _on_menu_pressed():
	Engine.time_scale = 1
	main.change_scene_to(main.menu_scn)
