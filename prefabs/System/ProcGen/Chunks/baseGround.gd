extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_size():
#	print("bg: ", $MeshInstance.scale.x)
#	return $MeshInstance.scale.x * 2
	var g = get_child(0).scale.x * 2
	return g
	
func queue_unload():
	if get_child_count() > 0:
		#get_child(0).queue_free()
		get_child(0).call_deferred("free")
		return false
	else:
		return true
