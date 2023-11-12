extends Camera2D

signal camera_move(move_to)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _move_camera(move_To):
	print("mmm")
	self.position = move_To
	if(true):#would check if camera has actually moved here
		print("{HMM thirty}")
		camera_move.emit(self.position)
	pass
