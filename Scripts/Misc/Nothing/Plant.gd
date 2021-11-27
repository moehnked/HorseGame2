tool

extends Spatial

export(int,0,7) var xo = 1
export(int,0,7) var yo = 0
export(int,0,4) var isBillboard = 0

func _ready():
	$MeshInstance.get_surface_material(0).distance_fade_mode = 2
	$MeshInstance.get_surface_material(0).distance_fade_min_distance = 160
	$MeshInstance.get_surface_material(0).distance_fade_max_distance = 70
	$MeshInstance.get_surface_material(0).uv1_offset.x = 0.125 * xo
	$MeshInstance.get_surface_material(0).uv1_offset.y = 0.125 * yo
	$MeshInstance.get_surface_material(0).params_billboard_mode = isBillboard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		$MeshInstance.get_surface_material(0).uv1_offset.x = 0.125 * xo
		$MeshInstance.get_surface_material(0).uv1_offset.y = 0.125 * yo
		$MeshInstance.get_surface_material(0).params_billboard_mode = isBillboard
	
	pass
