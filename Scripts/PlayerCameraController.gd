extends Camera2D

signal camera_move(move_to, camera_position, playerOffset)#offset will contain the players current size and the "center" of the player character to display

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _move_camera(move_To, playerOffset):
	self.position = move_To
	if(true):#would check if camera has actually moved here
		camera_move.emit(move_To, self.position, playerOffset)
	pass

func _resize_camera(window_size):
	self.zoom = Vector2(2.0, 2.0)
	pass
