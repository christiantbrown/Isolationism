extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mainVP:Viewport = get_tree().get_root().get_viewport()
	self.size = mainVP.size
	
	var childBox:ColorRect = self.get_child(0)
	
	childBox.size = mainVP.size
	childBox.position = mainVP.positions
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
