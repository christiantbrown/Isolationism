extends CharacterBody2D

signal characterMove(movement, playerOffset)#offset will be where the center of the player is

var characterCamera:Camera2D;

#input vars below
var inputLeft:bool = false
var inputRight:bool = false
var inputDown:bool = false
var inputUp:bool = false


var moveSpeed:float = 10.0


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
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#use this function for all character movement and non animation actions
	if(inputRight || inputLeft || inputDown || inputUp):
		_move(inputLeft, inputRight, inputDown, inputUp, delta)
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
			print("Collision X: NORMAL: " + str(testXColl.get_normal()) + " ||| Point: " + str(testXColl.get_position()))
			xCanMove = false
	if(direction.y != 0):
		var testYColl:KinematicCollision2D = move_and_collide(Vector2(0, direction.y) * delta, true, .2, true)
		if(testYColl):
			print("Collision Y: NORMAL: " + str(testYColl.get_normal()) + " ||| Point: " + str(testYColl.get_position()))
			yCanMove = false
	
	#if no collision add movement, dont see any thing else that is needed if more things are wanted add them to this move function
	if(xCanMove):
		self.position.x += direction.x * delta
	if(yCanMove):
		self.position.y += direction.y * delta
		
	characterMove.emit(self.position, Vector2(0, 0))
	pass







