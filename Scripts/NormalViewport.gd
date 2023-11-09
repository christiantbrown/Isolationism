extends SubViewport

@export_range (1, 10) var rLayer:int;
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mainVP:Viewport = get_tree().get_root().get_viewport()
	self.size = mainVP.size
	
	var childBox:ColorRect = self.get_child(0)
	
	childBox.size = mainVP.size
	#childBox.position = self.position
	
	var camera:Camera2D = self.get_child(1)
	
	camera.zoom = mainVP.get_camera_2d().zoom
	camera.global_position = mainVP.get_child(0).global_position
	camera.position = mainVP.get_camera_2d().position
	
	var watchVP:Viewport = self.get_child(2)
	
	print(watchVP.name)
	#print(watchVP.canvas_cull_mask)
	#watchVP.set_canvas_cull_mask_bit(2, false)
	#watchVP.set_canvas_cull_mask_bit(0, false)
	#watchVP.set_canvas_cull_mask_bit(4, false)
	#watchVP.set_canvas_cull_mask_bit(rLayer, true)
	#watchVP.set_canvas_cull_mask_bit(2, true)
	watchVP.set_canvas_cull_mask_bit(rLayer -1 , true)
	#print(watchVP.canvas_cull_mask)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
