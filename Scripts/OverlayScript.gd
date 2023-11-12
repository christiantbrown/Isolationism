extends CanvasLayer
@export_range(1, 10) var objectLayer:int = 2;

var childMat:ShaderMaterial;
var overLay:ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	overLay = self.get_child(0)
	childMat = self.get_child(0).material
	self.get_child(1).rLayer = objectLayer
	self.visible = true;

	
	get_tree().get_root().get_viewport().set_canvas_cull_mask_bit(objectLayer - 1, false);
	
	get_tree().get_root().get_camera_2d().camera_move.connect(_overlay_move)
	_overlay_move(get_tree().get_root().get_camera_2d().position)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(self.get_parent().heartBeat)
	childMat.set_shader_parameter("heartbeat", self.get_parent().heartBeat)
	pass
	
func _overlay_move(_move_to):
	overLay.position = _move_to - overLay.size / 2
	print("HMMM")
	pass
