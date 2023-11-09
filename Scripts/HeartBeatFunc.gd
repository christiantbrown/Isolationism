extends CanvasLayer

@export var normalMap:Texture2D;
@export var playerRef:ColorRect;
@export var heartbeat:float;
@export var heartRadius:float;
var mainVP:Viewport;
var mainCamera:Camera2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	mainVP = get_tree().get_root().get_viewport()
	mainCamera = mainVP.get_camera_2d()
	
	var overlay:ColorRect = self.get_child(0)
	
	
	
	overlay.size = mainVP.size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_tree().get_root().get_child(0).name)
	
	#finding the center of the square right now
	#var playerPos:Vector2 = playerRef.position + playerRef.size / 2
	
	#var pixelPPos:Vector2i = Vector2i(playerPos) - Vector2i(mainCamera.position) + (mainVP.size / 2)
	
	
	#this is what we make an texture into eventually, but we start by making an image
	#var newTexture:ImageTexture = ImageTexture.new()
	
	#var newImage:Image = Image.new()
	#newImage.create(normalMap.get_width(), normalMap.get_height(), false, Image.FORMAT_L8)
	
	pass
