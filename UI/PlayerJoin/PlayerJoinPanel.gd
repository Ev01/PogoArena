extends Panel

#export (Array, String) var control_scheme1
#export (Array, String) var control_scheme2
#export (Array, String) var control_scheme3

var joined = false
var control = []
var player_num = 1
var colour = Color.white setget _set_colour
var player_name = "Player"

#onready var control_schemes = [control_scheme1,  control_scheme2, control_scheme3]
onready var player_preview = $PlayerPreview
onready var control_lbl = $Controls
onready var press_key = $PressKey
onready var remove_btn = $RemoveBtn

func _ready():
	player_preview.hide()
	remove_btn.hide()


func join(control_scheme, p_colour, p_player_num, p_name):
	if not joined:
		_set_colour(p_colour)
		control = control_scheme
		player_num = p_player_num
		player_name = p_name
		
		player_preview.show()
		press_key.hide()
		remove_btn.show()
		for control in control_scheme:
			for action in InputMap.get_action_list(control):
				if action is InputEventKey:
					control_lbl.text += action.as_text() + " "
		
		joined = true


func unjoin():
	if joined:
		player_preview.hide()
		press_key.show()
		remove_btn.hide()
		control_lbl.text = ""
		joined = false





func _on_RemoveBtn_pressed():
	unjoin()


func _set_colour(value):
	colour = value
	player_preview.modulate = colour
