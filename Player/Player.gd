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

var rot_since_bounce = 0.0
var highspeed_bounce = true

export (PackedScene) var trick_text


signal score_changed(current_score)

var col_pos

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
			if body != self:
				do_bounce(body)
				break
	
	rot_since_bounce += angular_velocity*delta
	
	if abs(rot_since_bounce) >= deg2rad(360):
		done_trick("FLIP!")
		rot_since_bounce = 0
	
	if linear_velocity.length() >= 1450 and highspeed_bounce == true:
		done_trick("HIGH SPEED!")
		highspeed_bounce = false

func kill(body):
	
	if not is_dead:
		print("Player ", player_num, " Killed by ", body)
		if last_touched_by:
			last_touched_by.give_frag()
		
		if body.is_in_group("Player"):
			# Apply force away from the killer
			var blast_force = (position - body.position).normalized() * blast_power
			apply_central_impulse(blast_force)
		
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
		sprite.modulate = Color(1,1,1)
		
		# Wait one frame to prevent dying on the first frame
		yield(get_tree(), "idle_frame")
		is_dead = false


func do_bounce(body):
	if body != self:
		#apply_central_impulse(Vector2(linear_velocity.length() * mass + bounce_power, 0).rotated(rotation - PI/2))
		apply_central_impulse(Vector2(bounce_power, 0).rotated(rotation - PI/2))
		rot_since_bounce = 0
		highspeed_bounce = true


func give_frag():
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

