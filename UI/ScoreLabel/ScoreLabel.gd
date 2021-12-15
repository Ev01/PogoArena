extends Label


func set_player(player_node):
	player_node.connect("got_frag", self, "_on_player_frag")
	add_color_override("font_color", player_node.modulate)

func _on_player_frag(current_score):
	text = str(current_score)
