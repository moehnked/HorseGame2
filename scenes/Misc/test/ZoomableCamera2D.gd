extends Camera2D

export(float) var zoomSpeed = 0.5

var target = position
var zoomScale = Vector2.ONE


func _process(delta):
	zoom = zoom.linear_interpolate(zoomScale, zoomSpeed)
	position = position.linear_interpolate(target, zoomSpeed)
	pass

func reset_zoom():
	set_zoom(1, self)

func set_zoom(sca = 2, _target = self):
	target = _target if _target is Vector2 else _target.position
	zoomScale = Vector2.ONE * sca
