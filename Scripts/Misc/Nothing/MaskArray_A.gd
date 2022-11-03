tool
extends MeshInstance

export var idx = 0
export var idy = 0

func _ready():
	set_surface_material(0, get_surface_material(0).duplicate(7))
	get_surface_material(0).uv1_offset.x = 0.333 * idx
	get_surface_material(0).uv1_offset.y = 0.5 * idy


func _process(delta):
	if Engine.editor_hint:
		get_surface_material(0).params_depth_draw_mode = SpatialMaterial.DEPTH_DRAW_ALPHA_OPAQUE_PREPASS
		get_surface_material(0).flags_do_not_receive_shadows = true
		get_surface_material(0).uv1_offset.x = 0.333 * idx
		get_surface_material(0).uv1_offset.y = 0.5 * idy
