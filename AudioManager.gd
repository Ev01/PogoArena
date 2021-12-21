extends Node2D



func play_sound(clip_path, pitch_amount, vol):
	var audio_player = AudioStreamPlayer.new()
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
