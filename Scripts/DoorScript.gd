extends CharacterBody2D

var originalRotation:float
var opening:bool = false
var closing:bool = false
@export var rotateAmouunt:float = 1
@export var rotateTime:float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	originalRotation = self.rotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if opening:
		if(rotateAmouunt > 0):
			self.rotation = minf((self.rotation + rotateAmouunt * (delta / rotateTime)), originalRotation + rotateAmouunt)
		else:
			self.rotation = maxf((self.rotation + rotateAmouunt * (delta / rotateTime)), originalRotation + rotateAmouunt)
		if(self.rotation == originalRotation + rotateAmouunt):
			opening = false
		
		pass
	elif closing:
		if(rotateAmouunt > 0):
			self.rotation = maxf((self.rotation - rotateAmouunt * (delta / rotateTime)), originalRotation)
		else:
			self.rotation = minf((self.rotation - rotateAmouunt * (delta / rotateTime)), originalRotation)
		if(self.rotation == originalRotation):
			closing = false
	
	pass

func _interact_test(interact_info):
	if !opening && !closing:
		if(self.rotation != originalRotation):
			closing = true
		else:
			opening = true
	pass
