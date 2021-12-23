extends Label

# countdown_ended is called by the animation when it says "fight!"
signal countdown_ended()
onready var count_down_anim_player = $CountdownPlayer

func start_countdown():
	count_down_anim_player.play("Countdown")
	yield(count_down_anim_player, "animation_finished")
	count_down_anim_player.play("RESET")
	
