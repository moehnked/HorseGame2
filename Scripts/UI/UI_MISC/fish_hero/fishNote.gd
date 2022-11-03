extends Area2D


var speed = 10
export(Array, Texture) var sprites


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = Utils.get_random(sprites)
	pass # Replace with function body.

func set_speed(lvl):
	speed += lvl

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = lerp(position.y, position.y + (1 * speed), 0.5)
	pass
