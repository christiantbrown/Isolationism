extends CharacterBody2D

signal characterMove(movement)

var characterCamera:Camera2D;

# Called when the node enters the scene tree for the first time.
func _ready():

	characterCamera = self.get_tree().get_root().get_camera_2d()

	self.get_tree().get_root().connect("size_changed", _resize_func)
	
	characterCamera._move_camera(self.position)
	
	self.characterMove.connect(characterCamera._move_camera)
	

	
	pass # Replace with function body.


func _resize_func():
	print(get_viewport_rect().size)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#use this function for all character movement and non animation actions
	
	#_move()
	pass
	
func _move():
	self.position += Vector2(1, 1)
	characterMove.emit(self.position)
