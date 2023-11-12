extends SubViewport

var camera:Camera2D

@export_range (1, 10) var rLayer:int;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mainVP:Viewport = get_tree().get_root().get_viewport()
	self.size = mainVP.size
	
	var childBox:ColorRect = self.get_child(0)
	
	childBox.size = mainVP.size
	#childBox.position = self.position
	
	camera = self.get_child(1)
	
	camera.zoom = mainVP.get_camera_2d().zoom
	camera.global_position = mainVP.get_child(0).global_position
	camera.position = mainVP.get_camera_2d().position
	
	var watchVP:Viewport = self.get_child(2)
	

	watchVP.set_canvas_cull_mask_bit(rLayer -1 , true)
	
	
	

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
