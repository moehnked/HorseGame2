extends Sprite


var speed = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if(scale.x > owner.iconScale):
		modulate.a += 0.02 if modulate.a < 1 else 0
		scale = scale.linear_interpolate(Vector2(owner.iconScale,owner.iconScale), delta * speed)
