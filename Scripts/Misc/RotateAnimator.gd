tool
extends Sprite

export(Array, float) var steps
export(int) var step = 0
export(float) var weight = 0.03
export(float) var thresh = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, steps[step], weight)
	if abs(steps[step] - rotation_degrees) < thresh:
		step = (step + 1) % steps.size()
#	pass
