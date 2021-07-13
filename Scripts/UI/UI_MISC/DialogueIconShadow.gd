extends Sprite


var speed = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(scale.x < owner.iconScale):
		modulate.a += 0.01
		scale = scale.linear_interpolate(Vector2(owner.iconScale,owner.iconScale), delta * speed)
