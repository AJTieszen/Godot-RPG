extends CharacterBody3D

const SPEED = 15
const RUNSPEED = 30
const JUMP_VELOCITY = 5.5
const DEATHPLANE = -20
const CSPEED = 2
const ZOOM_RATE_FAR = -30
const ZOOM_RATE_NEAR = -3
const ZOOM_BLEND_RANGE = 40
const HIGH_ANGLE_LIMIT = -85
const LOW_ANGLE_LIMIT = 45

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = SPEED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		if (global_position.y < DEATHPLANE):
			get_tree().change_scene_to_file("res://GD Scenes/Title Screen.tscn")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle run
	if Input.is_action_pressed("run"):
		speed = RUNSPEED
	else:
		speed = SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Rotate Camera
	var c_input_dir = Input.get_vector("c_left", "c_right", "c_up", "c_down")
	var length1
	var length2
	var length = 5.0
	
	if c_input_dir:
		var spring = $SpringArm3D
		var spr_rot_deg = rad_to_deg(spring.rotation.x)
		var blend = (spr_rot_deg + ZOOM_BLEND_RANGE) / (ZOOM_BLEND_RANGE)
		
		# Rotate Camera
		rotate_y(c_input_dir.x * delta * CSPEED * -1)
		spring.rotate_x(c_input_dir.y * delta * CSPEED * -1)
		spring.rotation.x = clamp(spring.rotation.x, deg_to_rad(HIGH_ANGLE_LIMIT), deg_to_rad(LOW_ANGLE_LIMIT))
		
		# Zoom Camera based on elevation
		length1 = spring.rotation.x * ZOOM_RATE_FAR + 5.0
		length2 = spring.rotation.x * ZOOM_RATE_NEAR + 5.0
		
		if(spr_rot_deg < -ZOOM_BLEND_RANGE): length = length1		# Far
		elif (spr_rot_deg > 0): length = length2					# Near
		else: length = lerp(length1, length2, blend)				# Blend
			
		spring.set_length(length)
	
	move_and_slide()  
	
