extends CharacterBody2D

signal characterMove(movement, playerOffset)#offset will be where the center of the player is

var characterCamera:Camera2D;

#input vars below
var inputLeft:bool = false
var inputRight:bool = false
var inputDown:bool = false
var inputUp:bool = false


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
		_move(inputLeft, inputRight, inputDown, inputUp)
	pass
	
func _move(left, right, down, up):
	var direction:Vector2 = Vector2(0,0)
	
	direction.x -= 1 if left else 0
	direction.x += 1 if right else 0
	direction.y += 1 if down else 0
	direction.y -= 1 if up else 0
	
	self.position += direction
	characterMove.emit(self.position, Vector2(0, 0))
	pass







