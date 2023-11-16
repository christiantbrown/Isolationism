extends CanvasLayer
@export_range(1, 10) var objectLayer:int = 2;
@export_range(1, 10) var selectedLayer:int = 3;

var childMat:ShaderMaterial;
var overLay:ColorRect
var objectViewport:Viewport
var selectedViewport:Viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	overLay = self.get_child(0)
	childMat = self.get_child(0).material
	objectViewport = self.get_child(1)
	selectedViewport = self.get_child(2)

	objectViewport.rLayer = objectLayer
	selectedViewport.rLayer = selectedLayer
	self.visible = true;

	get_tree().get_root().get_viewport().set_canvas_cull_mask_bit(objectLayer - 1, false);
	get_tree().get_root().get_viewport().set_canvas_cull_mask_bit(selectedLayer - 1, false);
	

	
	var screenResolution:Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),  ProjectSettings.get_setting("display/window/size/viewport_height"))
	_size_change(screenResolution)
	objectViewport.size = screenResolution
	selectedViewport.size = screenResolution
	
	childMat.set_shader_parameter("objetMap", objectViewport.get_texture())
	childMat.set_shader_parameter("selectedMap", selectedViewport.get_texture())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	childMat.set_shader_parameter("heartbeat", self.get_parent().heartBeat)
	pass

func _size_change(_new_size):
	var sizeChange = overLay.size - _new_size
	overLay.position = +(sizeChange / 2)
	overLay.size = _new_size 
	pass
