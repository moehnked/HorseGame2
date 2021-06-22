extends Spatial

var source = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Area.scale += Vector3(0.1,0.1,0.1)
	pass


func initialize(args = {}):
	args = Utils.check(args, {"caller": null})
	source = args.caller

func _on_Area_body_entered(body):
	var other = null
	if body.has_method("fell"):
		other = body
	if body.get_parent() != null:
		if body.get_parent().has_method("fell"):
			other = body.get_parent()
	if other != null and source != null:
		source.call("locate_tree", other)
		queue_free()
	pass # Replace with function body.


func _on_TimeToLive_timeout():
	source.call("tree_not_found")
	queue_free()
	pass # Replace with function body.
