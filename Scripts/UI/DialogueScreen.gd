extends Control

export var speed = 2
var stop_point = 250


# Called when the node enters the scene tree for the first time.
func _ready():
	stop_point = Vector2($Container.position.x, OS.get_screen_size().y/2.8)
	pass # Replace with function body.

func _process(delta):
	raise_window(delta)

func raise_window(delta):
	if($Container.position.y > stop_point.y):
		print("yada")
		#$Container.position.y -= speed * delta
		#$Sprite.position = $Sprite.position.linear_interpolate(mouse_pos, delta * FOLLOW_SPEED)
		$Container.position = $Container.position.linear_interpolate(stop_point, delta * speed)
	pass
