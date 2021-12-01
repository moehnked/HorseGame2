tool
extends Spatial

export(Array, Texture) var rugs
export(int) var rugType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		$MeshInstance.get_surface_material(0).albedo_texture = rugs[rugType % rugs.size()]
	var c = transform.origin.normalized()
	$MeshInstance.get_surface_material(0).albedo_color = Color(1,1,1,1) - Color(c.x,c.y,c.z,0)
