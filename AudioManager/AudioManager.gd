extends Node2D



func play_sound(clip_path, pitch_amount, vol):
	""" Creates a sound and plays it.
	
	NOTE: This creates a new sound node and deletes it afterwards which is 
	bad for performance.
	
	Args:
		clip_path (str / Array of strs): The path of the audio file. If an array 
		  is passed a random one will be chosen.
		pitch_amount (float): The pitch of the played sound
		vol (float): The volume of the sound in dB.
	"""
	
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
	""" Plays a sound that already exists as a child node. 
	
	Args:
		node_name (str): The name of the child node.
		fade_duration (float): How long in seconds to fade in for.
		pitch_amount (float): The pitch of the played sound.
		volume (float): The volume of the played sound in dB.
	"""
	var node = get_node(node_name) as Sound
	node.pitch_scale = pitch_amount
	node.volume_db = volume
	if fade_duration:
		node.fade_in(fade_duration)
	else:
		node.play()


func stop_existing(node_name, fade_duration):
	""" Stops playing a child sound node.
	
	Args:
		node_name (str): Name of the child node to stop.
		fade_duration (float): How long in seconds to fade out.
	"""
	var node = get_node(node_name) as Sound
	if fade_duration:
		node.fade_out(fade_duration)
	else:
		node.stop()


func stop_music(fade_duration):
	for node in get_tree().get_nodes_in_group("Music"):
		if node.playing:
			node.fade_out(fade_duration)
