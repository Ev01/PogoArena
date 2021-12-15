extends WindowDialog


onready var play_again_btn = $PlayAgain
onready var menu_btn = $BackToMenu
onready var world = get_node("/root/Main/World")
onready var main = get_node("/root/Main")

func _ready():
	play_again_btn.connect("pressed", self, "_on_play_again_pressed")
	menu_btn.connect("pressed", self, "_on_menu_pressed")


func _on_play_again_pressed():
	main.load_new_game(world.player_count, world.max_score)


func _on_menu_pressed():
	main.change_scene_to(main.menu_scn)
