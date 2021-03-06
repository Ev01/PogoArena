extends HBoxContainer

# display_name: value pairs
export (Dictionary) var buttons

var current_value
var button_nodes = {}

onready var button_group = ButtonGroup.new()

func _ready():
	for child in get_children():
		child.queue_free()
	
	for name in buttons.keys():
		var new_button = Button.new()
		new_button.group = button_group
		new_button.toggle_mode = true
		new_button.text = name
		add_child(new_button)
		new_button.connect("pressed", self, "_on_button_pressed", [name])
		new_button.size_flags_horizontal = SIZE_EXPAND_FILL
		
		button_nodes[name] = new_button
	
	button_nodes["2"].pressed = true
	_on_button_pressed("2")
	


func _on_button_pressed(name):
	current_value = buttons[name]
