extends Camera2D


export var zoom_smoothing_enabled = true
export var zoom_speed = 10
export var min_zoom: float = 0.1
export var zoom_margin: float = 1
export var look_ahead_mult: float = 0.5

# Declare member variables here. Examples:
var is_shaking = false
var target_zoom = 1

var shake
var fade_out
onready var shake_timer = $ShakeTimer
var camera_limits: Array
onready var game = get_parent()
onready var resolution = Vector2(
	ProjectSettings.get_setting("display/window/size/width"), 
	ProjectSettings.get_setting("display/window/size/height"))

func _ready():
	yield(game, "game_ready")
	camera_limits = get_tree().get_nodes_in_group("CameraLimiter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	fit_to_players()
	
	# Zoom smoothing
	if zoom_smoothing_enabled:
		zoom = Vector2.ONE * lerp(zoom, target_zoom, zoom_speed * delta)
	else:
		zoom = target_zoom
	
	if is_shaking:
		shake = max(shake-(delta*fade_out)/shake_timer.wait_time,0)
		set_offset(Vector2(rand_range(-shake, shake), rand_range(-shake, shake)))
	else:
		set_offset(Vector2(0, 0))
	
	if shake_timer.is_stopped():
		is_shaking = false

func camera_shake(shake_amount, duration):
	is_shaking = true
	shake = shake_amount
	fade_out = shake_amount
	shake_timer.wait_time = duration
	shake_timer.start()


func fit_to_players():
	# The camera will stretch to fit around these points
	var points_to_fit = []
	
	for player in game.players:
		points_to_fit.append(player.position)
		points_to_fit.append(player.position + player.linear_velocity * look_ahead_mult)
	
	var new_rect_top_left : Vector2
	var new_rect_bottom_right : Vector2
	var initial_value_set = false
	
	for point in points_to_fit:
		if not initial_value_set:
			new_rect_top_left = point
			new_rect_bottom_right = point
			initial_value_set = true
			continue
		
		# Stretch rect to the right
		if point.x > new_rect_bottom_right.x:
			new_rect_bottom_right.x = point.x
		
		# Stretch rect to the left
		if point.x < new_rect_top_left.x:
			new_rect_top_left.x = point.x
		
		# Stretch rect to the bottom
		if point.y > new_rect_bottom_right.y:
			new_rect_bottom_right.y = point.y
		
		# Stretch rect upwards
		if point.y < new_rect_top_left.y:
			new_rect_top_left.y = point.y
	
	# Apply margin around players
	new_rect_top_left -= Vector2.ONE * zoom_margin * resolution / 2
	new_rect_bottom_right += Vector2.ONE * zoom_margin * resolution / 2
	
	# Limit camera so it stays within a certain bounds
	for point_limit_node in camera_limits:
		var point_limit = point_limit_node.position
		if point_limit_node.limit_left:
			new_rect_top_left.x = max(new_rect_top_left.x, point_limit.x)
		if point_limit_node.limit_up:
			new_rect_top_left.y = max(new_rect_top_left.y, point_limit.y)
		if point_limit_node.limit_right:
			new_rect_bottom_right.x = min(new_rect_bottom_right.x, point_limit.x)
		if point_limit_node.limit_down:
			new_rect_bottom_right.y = min(new_rect_bottom_right.y, point_limit.y)
	
	var new_rect_size = new_rect_bottom_right - new_rect_top_left
	
	#print(new_rect_top_left)
	
	position = new_rect_top_left + new_rect_size/2
	# Convert size in pixels to a zoom multiplier
	var new_zoom_x = new_rect_size.x / resolution.x
	var new_zoom_y = new_rect_size.y / resolution.y
	# Need to maintain aspect ratio, pick the biggest axis for both.
	target_zoom = Vector2.ONE * max(new_zoom_x, new_zoom_y)
	#target_zoom = Vector2.ONE * new_zoom_y
	# Sometimes zooming out to fit the aspect ratio will zoom past the boundary nodes,
	# in this case reposition the camera without zooming
	#for boundary_node in camera_limits:
	#	var boundary_pos = boundary_node.position
		# Position of top left of camera
		#var position_tl = position - new_rect_size/2
		#if boundary_node.limit_left and position.x - new_rect_size.x/2 < boundary_pos.x:
		#	position.x = boundary_pos.x + new_rect_size.x/2
		#elif boundary_node.limit_right and boundary_pos.x < position.x + new_rect_size.x/2:
		#	position.x = boundary_pos.x - new_rect_size.x/2
		
		#if boundary_node.limit_up and position.y < boundary_pos.y:
		#	position.y = boundary_pos.y
		#elif boundary_node.limit_down and boundary_pos.y < position.y + new_rect_size.y:
		#	position.y = boundary_pos.y - new_rect_size.y
	#target_zoom = Vector2(new_zoom_x, new_zoom_y)
		
		
