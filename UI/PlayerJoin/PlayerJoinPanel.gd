extends Panel

#export (Array, String) var control_scheme1
#export (Array, String) var control_scheme2
#export (Array, String) var control_scheme3
var skin_data setget _set_skin_data
var joined = false
# Will be a list of Input Actions defined in the InputMap that this player uses as controls.
var control = []
var player_num = 1
var colour = Color.white setget _set_colour
var player_name = "Player"

#onready var control_schemes = [control_scheme1,  control_scheme2, control_scheme3]
onready var player_preview = $PlayerPreview
onready var control_lbl = $Controls
onready var press_key = $PressKey
onready var remove_btn = $RemoveBtn
onready var skins = $Skins

func _ready():
	player_preview.hide()
	remove_btn.hide()
	skins.hide()
	for skin_button in skins.get_children():
		skin_button.connect("toggled", self, "_on_skin_button_toggled", [skin_button])
	
	# Start with the first skin button pressed
	skins.get_child(0).pressed = true
	

func join(control_scheme, p_colour, p_player_num, p_name, p_skin_data = null):
	if not joined:
		_set_colour(p_colour)
		control = control_scheme
		player_num = p_player_num
		player_name = p_name
		if p_skin_data:
			self.skin_data = p_skin_data
			update_pressed_skin_button()
		
		player_preview.show()
		press_key.hide()
		remove_btn.show()
		skins.show()
		
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
		skins.hide()
		
		control_lbl.text = ""
		joined = false


func update_pressed_skin_button():
	for skin_button in skins.get_children():
		if skin_button.skin_data == skin_data:
			skin_button.pressed = true
			break


func _on_RemoveBtn_pressed():
	unjoin()


func _on_skin_button_toggled(button_pressed, skin_button):
	if button_pressed:
		self.skin_data = skin_button.skin_data


func _set_skin_data(value):
	skin_data = value
	player_preview.texture = skin_data.texture


func _set_colour(value):
	colour = value
	player_preview.modulate = colour
