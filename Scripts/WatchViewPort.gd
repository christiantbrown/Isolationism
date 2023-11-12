extends SubViewport

@export_range (1, 10) var renderLayer:int = 2;

var Cam:Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var ogViewPort:Viewport = get_tree().get_root().get_viewport()
	
	
	#grab the viewport of the scene the normalviewportcreator is attached too
	self.world_2d = ogViewPort.world_2d
	self.size = ogViewPort.size
	
	#grab camera and make its proportions and position equal to the normalviewports camera
	Cam = self.get_child(0)
	
	
	Cam.zoom = ogViewPort.get_camera_2d().zoom
	Cam.position = ogViewPort.get_camera_2d().position
	#self.set_canvas_cull_mask_bit(4, false);
	#for n in 20:
	#	self.set_canvas_cull_mask_bit(n + 2, false);
	#self.canvas_cull_mask = 0
	
	
	get_tree().get_root().get_camera_2d().camera_move.connect(_move)
	#_move(get_tree().get_root().get_camera_2d().position)

	#self.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),  ProjectSettings.get_setting("display/window/size/viewport_height"))
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _move(_char_move, _camera_pos, playerOffset):
	Cam.position = _camera_pos
	pass
