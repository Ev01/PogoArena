extends Label


func set_player(player_node):
	player_node.connect("got_frag", self, "_on_player_frag")

func _on_player_frag(current_score):
	text = str(current_score)
