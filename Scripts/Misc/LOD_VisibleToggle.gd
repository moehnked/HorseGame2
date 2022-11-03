extends Spatial

var lod_culled = true
export(bool) var haltProcessing = false

func hide():
	visible = false
	for c in get_children():
		c.visible = false
	lod_culled = false
	parse_processing()

func show():
	visible = true
	for c in get_children():
		c.visible = true
	lod_culled = true
	parse_processing()

func toggle():
	visible = !visible
	for c in get_children():
		c.visible = visible
	lod_culled = visible
	parse_processing()

func parse_processing():
	if haltProcessing:
		pause_mode = PAUSE_MODE_STOP if not lod_culled else PAUSE_MODE_INHERIT
		#for c in get_children():
			#c.pause_mode = PAUSE_MODE_STOP if not lod_culled else PAUSE_MODE_INHERIT
	pass

func save():
	return Utils.serialize_node(self)

func set(param, val):
	match param:
		"lod_culled":
			lod_culled = val
			visible = val
		_:
			.set(param,val)
