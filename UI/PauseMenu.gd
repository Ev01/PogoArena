extends PanelContainer

onready var match_settings_scr = $MarginContainer/Control/MatchSettingsScreen
onready var match_settings_node = match_settings_scr.get_node("MatchSettings")
onready var main_scr = $MarginContainer/Control/MainScreen
onready var current_screen = main_scr
onready var win_dialog = get_node("../WinDialog")
onready var game = get_node("/root/Main/Game")

var is_showing = false

func _ready():
	hide()


func _input(event):
	if Input.is_action_just_pressed("pause"):
		if not is_showing:
			pause()
		else:
			unpause()


func pause():
	change_screen(main_scr)
	is_showing = true
	show()
	get_tree().paused = true


func unpause():
	if current_screen == match_settings_scr:
		apply_match_settings()
	is_showing = false
	hide()
	get_tree().paused = false


func change_screen(screen):
	current_screen.hide()
	current_screen = screen
	current_screen.show()


func apply_match_settings():
	# Update the games settings to be the ones you just changed
	game.match_settings = match_settings_node.settings
	# Apply these settings
	game.update_match_settings()


func _on_MatchSettingsBtn_pressed():
	change_screen(match_settings_scr)
	# Update the match settings you see to be the settings the game has
	match_settings_node.settings = game.match_settings


func _on_BackButton_pressed():
	change_screen(main_scr)
	apply_match_settings()


func _on_ResumeBtn_pressed():
	unpause()


func _on_EndGameBtn_pressed():
	game.abort_game()
	unpause()
