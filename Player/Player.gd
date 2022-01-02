extends RigidBody2D

# How fast your pogo bounces
export var bounce_power = 500
# How fast your pogo rotates
export var rotation_torque = 100
# These are the actions in Input Map
export (String) var action_rotate_left = "rotate_left"
export (String) var action_rotate_right = "rotate_right"
# If you are player 1 this is 1, if player 2 this is 2 etc.
export (int) var player_num = 1
# When a player hits your head, exert a force of this much away from them.
export (float) var blast_power = 20000
export (PackedScene) var trick_text
export (PackedScene) var jump_particle
export (PackedScene) var explosion_particle

signal score_changed(current_score)
signal got_kill()
signal killed_self()

#used to be rot_since_last_bounce but now its not since last bounce
var rot_flip = 0.0
var highspeed_bounce = true
var col_pos
var col_normal
#used for wall jumps
var wall_jumped = false
#used for roof jumps
var roof_jumped = false
# The angle in radians of the normal of the last touched wall.
# Floor = -PI/2    Right wall = PI    Ceiling = PI/2    Left wall = 0 OR PI
var last_normal_rads

var player_name = "Player"
var is_dead = false
var is_invincible = false
var current_score = 0 setget _set_current_score
var last_touched_by
var gravity_multiplier = 1 setget _set_gravity_multiplier


onready var org_gravity_scale = gravity_scale
onready var sprite = get_node("Sprite")
onready var foot_area = $FootArea
onready var respawn_timer = $RespawnTimer
onready var respawn_time = respawn_timer.wait_time setget _set_respawn_time
onready var invincibility_timer = $InvincibilityTimer
onready var last_touched_timer = $LastTouchedTimer
onready var jump_particle_timer = $JumpParticleTimer
# The foot_kinematic is a kinematic body with the same collision as footarea. It only detects the
# normal of the Walls/floor/ceiling it touches.
# The foot_kinematic only detects collisions on layer 2, which has all the walls on it.
onready var foot_kinematic = $FootKinematic

onready var slide_audio = $SlidingSound


onready var game = get_node("/root/Main/Game")
onready var cam = game.get_node("Camera")
onready var audio_manager = get_node("/root/Main/AudioManager")
onready var world = get_parent()

#onready var respawn_point = get_node(respawn_point_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_Player_body_entered")
	$HeadArea.connect("area_entered", self, "_on_HeadArea_area_entered")
	$HeadArea.connect("body_entered", self, "_on_HeadArea_body_entered")
	$FootArea.connect("body_entered", self, "_on_FootArea_body_entered")


func _physics_process(delta):
	if not is_dead and !game.is_game_finished:
		# PROCESS INPUTS
		if Input.is_action_pressed(action_rotate_left):
			apply_torque_impulse(-rotation_torque)
		if Input.is_action_pressed(action_rotate_right):
			apply_torque_impulse(rotation_torque)
		
		# CHECK TO BOUNCE
		for body in foot_area.get_overlapping_bodies():
			if body != self:
				do_bounce(body)
				break
	
	# PLAY SLIDE SOUND
	if is_dead:
		if get_colliding_bodies():
			
			slide_audio.pitch_scale = linear_velocity.length() / 1000 + 0.5
			slide_audio.volume_db = min(linear_velocity.length() / 50 - 24, 0)
			if !slide_audio.playing:
				slide_audio.play()
		else:
			slide_audio.stop()
	else:
		slide_audio.stop()
	
	# reset last touched player after a certain amount of time
	if last_touched_timer.is_stopped():
		last_touched_by = null
	
	# DETECT WALL/ROOF JUMP
	
	# Get wall normals on foot
	# NOTE: wall normals are also gotten on the body in _integrate_forces
	var foot_col = foot_kinematic.move_and_collide(Vector2.ZERO, true, true, true)
	if foot_col:
		last_normal_rads = foot_col.normal.angle()
		detect_wall_jump()
	
	
	# DETECT TRICKS
	rot_flip += angular_velocity * delta
	if abs(rot_flip) >= deg2rad(360) && wall_jumped:
		done_trick("WALL FLIP!")
		rot_flip = 0
		wall_jumped = false
	
	if abs(rot_flip) >= deg2rad(360):
		done_trick("FLIP!")
		rot_flip = 0
	
	if linear_velocity.length() >= 1450 and highspeed_bounce == true:
		done_trick("HIGH SPEED!")
		highspeed_bounce = false

func kill(body):
	
	if not is_dead and not is_invincible:
		if body.is_in_group("PlayerFoot"):
			last_touched_by = body.get_parent()
		elif body.is_in_group("Player"):
			last_touched_by = body
		
		if last_touched_by:
			last_touched_by.give_frag()
		else:
			emit_signal("killed_self")
			
		
		if body.is_in_group("Player"):
			# Apply force away from the killer
			var blast_force = (position - body.position).normalized() * blast_power
			apply_central_impulse(blast_force)
		
		is_dead = true
		#Engine.time_scale = 0.2
		sprite.modulate = Color(0.2,0.2,0.2)
		
		var new_particle = explosion_particle.instance()
		cam.camera_shake(10,0.4)
		audio_manager.play_sound("res://Player/plosion.wav",rand_range(0.9,1.1),rand_range(-15,-5))
		new_particle.position = position
		world.add_child(new_particle)
		new_particle.emitting = true
		#new_particle.vel = linear_velocity
		
		respawn_timer.start()
		yield(respawn_timer, "timeout") # Wait for the respawn timer to finish
		respawn()

func respawn():
	#Engine.time_scale = 1
	if game.is_game_finished == false:
		position = game.choose_spawn(player_num)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		rotation = 0
		rot_flip = 0
		wall_jumped = false
		roof_jumped = false
		last_touched_by = null
		sprite.modulate = Color(1,1,1)
		is_dead = false
		# Wait 0.05 seconds frame to prevent dying on spawn.
		# This happens because on_HeadArea_body entered fires around 20 milliseconds late.
		# This means you could hit something 10 milliseconds before respawning and you would
		# die 10 milliseconds after respawn
		# NOTE: Make sure invincibilty timer is at least 0.02 or this will happen
		invincibility_timer.start()
		is_invincible = true
		yield(invincibility_timer, "timeout")
		is_invincible = false


func do_bounce(body):
	if body != self:
		#apply_central_impulse(Vector2(linear_velocity.length() * mass + bounce_power, 0).rotated(rotation - PI/2))
		apply_central_impulse(Vector2(bounce_power, 0).rotated(rotation - PI/2))
		#rot_flip = 0
		highspeed_bounce = true
		
		if jump_particle_timer.is_stopped():
			var new_particle = jump_particle.instance()
			new_particle.position = $ParticleSpawn.global_position
			new_particle.rotation = rotation
			world.add_child(new_particle)
			new_particle.emitting = true
			jump_particle_timer.start()


func give_frag():
	emit_signal("got_kill")


func done_trick(text):
	# Creates the trick label
	var text_inst = trick_text.instance()
	game.add_child(text_inst)
	text_inst.text = text
	text_inst.rect_position = position


func detect_wall_jump():
	if (rad2deg(last_normal_rads) >= 165 && rad2deg(last_normal_rads) <= 195 or 
			rad2deg(last_normal_rads) >= -15 && rad2deg(last_normal_rads) <= 15):
		wall_jumped = true
	else:
		wall_jumped = false
	if rad2deg(last_normal_rads) >= 90 - 15 && rad2deg(last_normal_rads) <= 90 + 15:
		roof_jumped = true
	else:
		roof_jumped = false


func _on_FootArea_body_entered(body):
	if body != self: 
		if not is_dead:
			audio_manager.play_sound(["res://Player/pogojump.ogg", "res://Player/pogojump2.ogg", "res://Player/pogojump3.ogg"], rand_range(0.9, 1.2), rand_range(-6, 0))
		if body.is_in_group("Player"):
			last_touched_by = body
			last_touched_timer.start()
		if body.is_in_group("PlayerFoot"):
			last_touched_by = body
			last_touched_timer.start()


func _on_HeadArea_body_entered(body):
	if body.is_in_group("Player"):
		if wall_jumped:
			done_trick("KAMIKAZE!")
		if roof_jumped:
			done_trick("KAMIKAZE!")
	if body != self:
		kill(body)


func _on_HeadArea_area_entered(area):
	if area.is_in_group("PlayerFoot"):
		kill(area)


func _on_Player_body_entered(body):
	if body.is_in_group("Player"):
		last_touched_by = body
		last_touched_timer.start()


func _integrate_forces( state ):
	if state.get_contact_count() >= 1 && state.get_contact_collider_object(0).is_in_group("Player") == false:
		#print(wall_jumped, " ", roof_jumped)
		col_pos = state.get_contact_local_position(0)
		last_normal_rads = state.get_contact_local_normal(0).angle()
		detect_wall_jump()


func _set_current_score(value):
	current_score = value
	emit_signal("score_changed", current_score)


func _set_gravity_multiplier(value):
	gravity_multiplier = value
	gravity_scale = org_gravity_scale * gravity_multiplier


func _set_respawn_time(value):
	respawn_time = value
	respawn_timer.wait_time = value
