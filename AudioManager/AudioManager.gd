extends Node2D



func play_sound(clip_path, pitch_amount, vol):
	var audio_player = Sound.new()
	add_child(audio_player)
	
	#if there is an array of clips it will play a random one
	if typeof(clip_path) == TYPE_ARRAY:
		audio_player.stream = load(clip_path[randi() % len(clip_path)])
	else:
		audio_player.stream = load(clip_path)
	
	audio_player.pitch_scale = pitch_amount
	audio_player.volume_db = vol
	audio_player.play()
	
	#delete the AudioStreamPlayer when it is done playing the sound
	audio_player.connect("finished", audio_player, "queue_free")


func play_existing(node_name, fade_duration = 0, pitch_amount = 1, volume = 0):
	var node = get_node(node_name) as Sound
	node.pitch_scale = pitch_amount
	node.volume_db = volume
	if fade_duration:
		node.fade_in(fade_duration)
	else:
		node.play()


func stop_existing(node_name, fade_duration):
	var node = get_node(node_name) as Sound
	if fade_duration:
		node.fade_out(fade_duration)
	else:
		node.stop()


func stop_music(fade_duration):
	for node in get_tree().get_nodes_in_group("Music"):
		if node.playing:
			node.fade_out(fade_duration)
