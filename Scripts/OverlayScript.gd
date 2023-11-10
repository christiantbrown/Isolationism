extends CanvasLayer
@export_range(1, 10) var objectLayer:int = 2;

var childMat:ShaderMaterial;
# Called when the node enters the scene tree for the first time.
func _ready():
	childMat = self.get_child(0).material
	self.get_child(1).rLayer = objectLayer
	self.visible = true;

	
	get_tree().get_root().get_viewport().set_canvas_cull_mask_bit(objectLayer - 1, false);
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(self.get_parent().heartBeat)
	childMat.set_shader_parameter("heartbeat", self.get_parent().heartBeat)
	pass
