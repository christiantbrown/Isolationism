extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var inputLeft:bool = false
var inputRight:bool = false
var inputDown:bool = false
var inputUp:bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.#
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):#this function triggers when any input is pressed so we will save which inputs are pressed down in here, to access them in the physics proccess
	
	if event.is_action_pressed("Input_Left"):
		inputLeft = true
	elif event.is_action_released("Input_Left"):
		inputLeft = false
	if event.is_action_pressed("Input_Right"):
		inputRight = true
	elif event.is_action_released("Input_Right"):
		inputRight = false
	if event.is_action_pressed("Input_Up"):
		inputUp = true
	elif event.is_action_released("Input_Up"):
		inputUp = false
	if event.is_action_pressed("Input_Down"):
		inputDown = true
	elif event.is_action_released("Input_Down"):
		inputDown = false
	
	pass

func _physics_process(delta):
	# i thought the base controller would be better, what is this shit
	
	
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
