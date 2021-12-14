extends RigidBody2D


export var bounce_power = 500
export var rotation_torque = 100
export (String) var action_rotate_left = "rotate_left"
export (String) var action_rotate_right = "rotate_right"
export (NodePath) var respawn_point_path

var is_dead = false

onready var foot_area = $FootArea
onready var respawn_timer = $RespawnTimer
onready var respawn_point = get_node(respawn_point_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not is_dead:
		
		if Input.is_action_pressed(action_rotate_left):
			apply_torque_impulse(-rotation_torque)
		if Input.is_action_pressed(action_rotate_right):
			apply_torque_impulse(rotation_torque)
		
		for body in foot_area.get_overlapping_bodies():
			bounce(body)


func kill():
	
	is_dead = true
	#Engine.time_scale = 0.2
	print("dead")
	respawn_timer.start()
	yield(respawn_timer, "timeout")
	respawn()
	


func respawn():
	#Engine.time_scale = 1
	position = respawn_point.position
	linear_velocity = Vector2.ZERO
	rotation = 0
	is_dead = false


func bounce(body):
	if body != self:
		print(linear_velocity.length())
		
		#apply_central_impulse(Vector2(linear_velocity.length() * mass + bounce_power, 0).rotated(rotation - PI/2))
		apply_central_impulse(Vector2(bounce_power, 0).rotated(rotation - PI/2))


func _on_Player_body_entered(body):
	pass


func _on_FootArea_body_entered(body):
	pass


func _on_HeadArea_body_entered(body):
	if body != self:
		kill()
