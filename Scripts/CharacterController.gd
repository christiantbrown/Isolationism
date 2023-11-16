extends CharacterBody2D

signal characterMove(movement, playerOffset)#offset will be where the center of the player is

var characterCamera:Camera2D;

#input vars below
var inputLeft:bool = false
var inputRight:bool = false
var inputDown:bool = false
var inputUp:bool = false
var inputInteract:bool = false
var mousePos:Vector2 = Vector2(0,0)
var mouseMoved:bool = false


var moveSpeed:float = 10.0
var lastVelocity:Vector2 = Vector2(0,0)

var lastTargeted = null
@export var targetedObjectLayer:int = 3
@export var objectLayer:int = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	characterCamera = self.get_tree().get_root().get_camera_2d()
	
	characterCamera._move_camera(self.position, Vector2(0,0))
	
	self.characterMove.connect(characterCamera._move_camera)
	
	var sceneChildren = get_tree().get_root().get_child(0).get_children()
	var overlay = sceneChildren.filter(func(child):
		if(child.name == "HeartBeatOverlay"):
			return true
		return false
		)
	if(overlay.size() > 0):
		self.characterCamera.camera_move.connect(overlay[0].get_child(0)._move)
	characterMove.emit(self.position, Vector2(0, 0))
	
	
	pass # Replace with function body.

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
	if event is InputEventMouseMotion:
		mousePos = event.position
		mouseMoved = true
	if event.is_action_pressed("Input_Interact"):
		inputInteract = true
	elif event.is_action_released("Input_Interact"):
		inputInteract = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#use this function for all character movement and non animation actions
	if(inputRight || inputLeft || inputDown || inputUp):
		_move(inputLeft, inputRight, inputDown, inputUp, delta)
		_mouse_raycast_object_check(self.position, mousePos)
	elif(mouseMoved):
		_mouse_raycast_object_check(self.position, mousePos)
	if(inputInteract):
		_interact()
	pass
	
func _move(left, right, down, up, delta):
	var direction:Vector2 = Vector2(0,0)
	
	direction.x -= moveSpeed if left else 0
	direction.x += moveSpeed if right else 0
	direction.y += moveSpeed if down else 0
	direction.y -= moveSpeed if up else 0
	
	
	var xCanMove:bool = true
	var yCanMove:bool = true
	
	#test if there is collision in both y and x direction to deal with corners
	if(direction.x != 0):
		var testXColl:KinematicCollision2D = move_and_collide(Vector2(direction.x, 0) * delta, true, .2, true)
		if(testXColl):
			print("Collision X: NORMAL: " + str(testXColl.get_normal()) + " ||| Point: " + str(testXColl.get_position()) + " ||| Depth: " + str(testXColl.get_depth()))
			if(testXColl.get_normal().x != 0):
				xCanMove = false
	if(direction.y != 0):
		var testYColl:KinematicCollision2D = move_and_collide(Vector2(0, direction.y) * delta, true, .2, true)
		if(testYColl):
			print("Collision Y: NORMAL: " + str(testYColl.get_normal()) + " ||| Point: " + str(testYColl.get_position()) + " ||| Depth: " + str(testYColl.get_depth()))
			if(testYColl.get_normal().y != 0):
				yCanMove = false
	
	#if no collision add movement, dont see any thing else that is needed if more things are wanted add them to this move function
	if(xCanMove):
		self.position.x += direction.x * delta
		lastVelocity.x = direction.x
	else:
		lastVelocity.x = 0
	if(yCanMove):
		self.position.y += direction.y * delta
		lastVelocity.y = direction.y
	else:
		lastVelocity.y = 0
	characterMove.emit(self.position, Vector2(0, 0))
	pass

func _mouse_raycast_object_check(playerPos, MousePos):
	mouseMoved = false
	
	var world:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	#have to add the camera left corner position to the mouse pos to get real world pos from the mouse pos
	var realMousePos:Vector2 = mousePos + (characterCamera.position - Vector2(self.get_tree().get_root().get_viewport().size / 2))
	var cast:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(playerPos, realMousePos, collision_mask, [self])
	
	
	var result:Dictionary = world.intersect_ray(cast)

	#if the result does not have anything in it, there is no hit
	if(result.size() != 0):
		#this means there is a hit
		if(result.collider != lastTargeted):
			#hit is different from last hit
			if(lastTargeted != null):
				#last hit is not null so change its layer
				lastTargeted.set_visibility_layer_bit(targetedObjectLayer - 1, false)
			if(result.collider.get_visibility_layer_bit(objectLayer - 1)):
				#object is an object, objects must be labeled 2 in bit mask
				result.collider.set_visibility_layer_bit(targetedObjectLayer - 1 , true)
				lastTargeted = result.collider
			else:
				#hit is not an object
				lastTargeted = null
		else:
			#same hit do nothing
			pass
	else:
		#this means that their is no hit
		if(lastTargeted != null):
			#remove last targeted from visibility list
			lastTargeted.set_visibility_layer_bit(targetedObjectLayer - 1, false)
			lastTargeted = null
	
	pass
	
func _interact():
	if(lastTargeted != null):
		lastTargeted._interact_test([self.position, lastVelocity, mousePos])
	else:
		pass
	pass







