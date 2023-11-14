extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if(self.name != "Area2D"):
		self.connect("area_entered", area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func area_entered(area):
	print("rawr" + str(self.name) + str(area.name))
