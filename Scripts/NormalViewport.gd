extends SubViewport

var camera:Camera2D

@export_range (1, 10) var rLayer:int = 2;
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
	camera.position = childBox.size / 2 + childBox.position

	
	var watchVP:Viewport = self.get_child(2)
	
	


	watchVP.set_canvas_cull_mask_bit(rLayer -1 , true)
	
	
	childBox.material.set_shader_parameter("My Array", watchVP)
	
	self.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),  ProjectSettings.get_setting("display/window/size/viewport_height"))
	childBox.size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),  ProjectSettings.get_setting("display/window/size/viewport_height"))
	get_tree().get_root().connect("size_changed", _size_Change)
	

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _size_Change():
	self.size = get_tree().get_root().get_viewport().size
	self.get_child(0).size = get_tree().get_root().get_viewport().size
	pass
