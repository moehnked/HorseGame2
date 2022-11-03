extends Spatial


var collisions = []
var biggestEV = Vector3.ZERO
var outputEV = Vector3.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		collisions.append(Vector3.ZERO)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	biggestEV = Vector3.ZERO
	for r in get_children():
		if r is RayCast:
			if r.is_colliding():
				biggestEV += r.cast_to
	biggestEV = biggestEV.normalized()
	$debugEV.target = biggestEV
	outputEV = biggestEV
	#$debugEV.visible = biggestEV.length() > 0.1
