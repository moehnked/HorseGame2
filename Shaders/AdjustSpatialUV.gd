extends MeshInstance

var uvOffset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mat = get_surface_material(0)
	uvOffset = mat.get_uv1_offset() + (Vector3(0.1,0,-0.1) * delta)
	mat.set_uv1_offset(uvOffset)
	#set_surface_material(0, mat)
	#print(uvOffset)
#	pass
