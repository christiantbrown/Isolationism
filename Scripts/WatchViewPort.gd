extends SubViewport

@export_range (1, 10) var renderLayer:int;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var ogViewPort:Viewport = get_tree().get_root().get_viewport()
	
	
	#grab the viewport of the scene the normalviewportcreator is attached too
	self.world_2d = ogViewPort.world_2d
	self.size = ogViewPort.size
	
	#grab camera and make its proportions and position equal to the normalviewports camera
	var camera:Camera2D = self.get_child(0)
	
	camera.zoom = ogViewPort.get_camera_2d().zoom
	camera.position = ogViewPort.get_camera_2d().position
	#self.canvas_cull_mask = 0
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
