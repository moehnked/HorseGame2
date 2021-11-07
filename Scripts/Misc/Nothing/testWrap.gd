extends Node2D

var x = 48


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#x = Utils.wrap(x + 1, 0, 12)

	x = (x + 1) % 360
	print(x)
#	pass
