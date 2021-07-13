extends Area


export(NodePath) var target = null
export(NodePath) var warpPoint = null
export(bool) var x = true
export(bool) var y = true
export(bool) var z = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func warp(other):
	if target != null and warpPoint != null:
		var wp = get_node(warpPoint).global_transform.origin
		var oo = other.global_transform.origin
		other.global_transform.origin = Vector3(wp.x if x else oo.x, wp.y if y else oo.y, wp.z if z else oo.z)

func _on_WarpPoint_body_entered(body):
	if body == get_node(target):
		warp(body)
	pass # Replace with function body.
