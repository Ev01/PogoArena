extends ColorRect

signal fade_in_finished()
signal fade_out_finished()
signal scene_change_finished()

onready var anim_player = $AnimationPlayer

func fade_in(reversed = true):
	#anim_player.playback_speed
	material.set_shader_param("reversed", reversed)
	if reversed:
		anim_player.play("FadeIn")
	else:
		anim_player.play_backwards("FadeIn")
	yield(anim_player, "animation_finished")
	emit_signal("fade_in_finished")


func fade_out(reversed = true):
	material.set_shader_param("reversed", reversed)
	if reversed:
		anim_player.play_backwards("FadeIn")
	else:
		anim_player.play("FadeIn")
	yield(anim_player, "animation_finished")

	emit_signal("fade_out_finished")
