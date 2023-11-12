extends ColorRect
var Actualposition:Vector2 = Vector2(0,0)
var CharPos:Vector2 = Vector2(0,0)
var frameOne:bool = true
var funnyViewport:Viewport
var preSize:Vector2 = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = Actualposition
	funnyViewport = self.get_parent().get_child(1)
	self.material.set_shader_parameter("playerPos", CharPos)
	self.material.set_shader_parameter("objectMap", funnyViewport.get_texture())
	get_tree().get_root().connect("size_changed", _size_Change)
	preSize = self.size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if frameOne:#for some I cant set the position of this object before frame one, so i guess this works
		frameOne = false
		self.position = Actualposition
		self.material.set_shader_parameter("playerPos", CharPos)
		self.material.set_shader_parameter("objectMap", funnyViewport.get_texture())
	#print(self.position)
	pass

func _move(character_move, camera_pos, playerOffset):
	self.position = camera_pos - self.size / 2
	Actualposition = camera_pos - self.size / 2
	CharPos = character_move - self.position
	self.material.set_shader_parameter("playerPos", CharPos)
	if(funnyViewport != null):
		self.material.set_shader_parameter("objectMap", funnyViewport.get_texture())
	

func _size_Change():
	var previousSize:Vector2 = preSize
	var sizeDiff:Vector2 = Vector2(get_tree().get_root().get_viewport().size) - previousSize
	Actualposition -= sizeDiff / 2
	CharPos += sizeDiff / 2
	self.material.set_shader_parameter("playerPos", CharPos)
	self.position = Actualposition
	self.size = get_tree().get_root().get_viewport().size
	preSize = self.size
	pass 
