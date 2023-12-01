extends CharacterBody3D

# TODO: Remove this after Movement Demo
@export var locked_camera = false
@onready var camera1 = $CameraRig/Camera3D
@onready var camera2 = $CameraRig/Camera3D2
@onready var camera3 = $CameraRig/Camera3D3

@onready var camera_rig = $CameraRig
@onready var camera = camera1
@onready var cursor= $Cursor

@export var stamina = 100

@export var base_speed = 10
@export var sprint_speed = 25
var speed = base_speed

@export var camera_rotation_speed = 250
var friction = 0.875

var move_direction = Vector3()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	camera_rig.set_as_top_level(true)
	cursor.set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	
	# Camera Controllers
	camera_follows_player()
	rotate_camera(delta)
	look_at_cursor()
	
	# TODO: Remove this after Movement Demo
	change_camera_style()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Move
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(3)
	move_and_slide()
	
	# Player actions
	sprint()
	stamina_regen()
	
# TODO: Remove this after Movement Demo
func change_camera_style():
	if Input.is_key_pressed(KEY_1):
		locked_camera = false
		camera = camera1
	if Input.is_key_pressed(KEY_2):
		locked_camera = true
		camera = camera2
	if Input.is_key_pressed(KEY_3):
		locked_camera = true
		camera = camera3
		
	camera.make_current()

func sprint():
	if Input.is_action_pressed("sprint") and stamina > 0:
		speed = sprint_speed
		stamina -= 1
	else:
		speed = base_speed


func stamina_regen():
	if !Input.is_action_pressed("sprint") and stamina < 100:
		stamina += 1

func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos


func rotate_camera(delta):
	if Input.is_action_pressed("rotate_camera_cw") and !locked_camera:
		camera_rig.rotate_y(deg_to_rad(-camera_rotation_speed * delta)) 
	if Input.is_action_pressed("rotate_camera_ccw") and !locked_camera:
		camera_rig.rotate_y(deg_to_rad(camera_rotation_speed * delta)) 


func look_at_cursor():
	
	# Create a horizontal plane, and find a point where the ray intersects with it
	var player_pos = global_transform.origin
	var dropPlane  = Plane(Vector3(0, 1, 0), player_pos.y)
	
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from,to)
	
	# Set the position of cursor visualizer
	if cursor_pos:
		cursor.global_transform.origin = cursor_pos + Vector3(0,1,0)
		# Make player look at the cursor
		look_at(cursor_pos, Vector3.UP)
