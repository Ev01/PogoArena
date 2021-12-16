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
#used to be rot_since_last_bounce but now its not since last bounce
var rot_flip = 0.0
var highspeed_bounce = true

export (PackedScene) var trick_text


signal score_changed(current_score)

var col_pos
var col_normal
#used for wall jumps
var wall_jumped=false
var can_kick=false

onready var sprite = get_node("Sprite")


var is_dead = false
var current_score = 0
var last_touched_by

onready var foot_area = $FootArea
onready var respawn_timer = $RespawnTimer
onready var world = get_parent()
#onready var respawn_point = get_node(respawn_point_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_Player_body_entered")
	$HeadArea.connect("area_entered", self, "_on_HeadArea_area_entered")
	$HeadArea.connect("body_entered", self, "_on_HeadArea_body_entered")


func _physics_process(delta):
	if not is_dead and !world.is_game_finished:
		
		if Input.is_action_pressed(action_rotate_left):
			apply_torque_impulse(-rotation_torque)
		if Input.is_action_pressed(action_rotate_right):
			apply_torque_impulse(rotation_torque)
		
		for body in foot_area.get_overlapping_bodies():
			bounce(body)
	rot_flip += angular_velocity*delta
	
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
	if not is_dead:
		if last_touched_by:
			last_touched_by.give_frag()
		
		
		
		is_dead = true
		#Engine.time_scale = 0.2
		sprite.modulate = Color(0.2,0.2,0.2)
		respawn_timer.start()
		yield(respawn_timer, "timeout") # Wait for the respawn timer to finish
		respawn()

func respawn():
	#Engine.time_scale = 1
	if world.is_game_finished == false:
		position = world.choose_spawn(player_num)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		rotation = 0
		rot_flip = 0
		sprite.modulate = Color(1,1,1)
		is_dead = false


func bounce(body):
	if body != self:
		#apply_central_impulse(Vector2(linear_velocity.length() * mass + bounce_power, 0).rotated(rotation - PI/2))
		apply_central_impulse(Vector2(bounce_power, 0).rotated(rotation - PI/2))
		#rot_flip = 0
		highspeed_bounce = true


func give_frag():
	if can_kick:
		#if frag is off a wall then it is a kick
		done_trick("KICK!")
	current_score += 1
	emit_signal("score_changed", current_score)

func done_trick(text):
	var text_inst = trick_text.instance()
	world.add_child(text_inst)
	text_inst.rect_position = position
	text_inst.text = text

func _on_FootArea_body_entered(body):
	pass


func _on_HeadArea_body_entered(body):
	if body != self:
		#apply force at point of collision
		if body.is_in_group("Player"):
			apply_central_impulse((col_pos-position) * -200)
		kill(body)


func _on_HeadArea_area_entered(area):
	if area.is_in_group("PlayerFoot"):
		kill(area)


func _on_Player_body_entered(body):
	if body.is_in_group("Player"):
		last_touched_by = body

func _integrate_forces( state ):
	if(state.get_contact_count() >= 1):
		col_pos = state.get_contact_local_position(0)
		col_normal = state.get_contact_local_normal(0).angle()
		#this code a bit yuky
		if rad2deg(col_normal) >= 165 && rad2deg(col_normal) <= 195 or rad2deg(col_normal) >= -15 && rad2deg(col_normal) <= 15:
			wall_jumped=true
			can_kick=true
		else:
			wall_jumped=false
			can_kick=false

